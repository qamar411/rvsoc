import riscv_types::*;

module data_path #(
    parameter DMEM_DEPTH = 1024, 
    parameter IMEM_DEPTH = 1024
)(
    input logic clk, 
    input logic reset_n,

    // outputs to controller 
    output logic [6:0] opcode_id,
    output logic fun7_5_exe,
    output logic [2:0] fun3_exe, fun3_mem,
    output logic zero_mem,
    output logic [1:0] alu_op_exe,
    output logic jump_mem, 
    output logic branch_mem,

    // control signals from the controller 
    input logic reg_write_id, 
    input logic mem_write_id, 
    input logic mem_to_reg_id, 
    input logic branch_id, 
    input logic alu_src_id,
    input logic jump_id, 
    input logic lui_id,
    input logic auipc_id, 
    input logic jal_id,
    input logic [1:0] alu_op_id,

    input logic [3:0] alu_ctrl_exe,
    input logic pc_sel_mem,


    // forwarding unit stuff
    output wire [4:0] rs1_id,
    output wire [4:0] rs2_id,
    output wire [4:0] rs1_exe,
    output wire [4:0] rs2_exe,
    output wire [4:0] rs2_mem,
    output wire [4:0] rd_mem,
    output wire [4:0] rd_wb,
    output wire reg_write_mem,
    output wire reg_write_wb,

    input  wire forward_rd1_id,
    input  wire forward_rd2_id,
    input  wire [1:0] forward_rd1_exe,
    input  wire [1:0] forward_rd2_exe,
    input  wire forward_rd2_mem,


    // hazard handler data required from the data path
    output  wire mem_to_reg_exe,
    output  wire [4:0] rd_exe,

    // signals to control the flow of the pipeline
    input logic if_id_reg_clr, 
    input logic id_exe_reg_clr,
    input logic exe_mem_reg_clr,
    input logic mem_wb_reg_clr,

    input logic if_id_reg_en, 
    input logic id_exe_reg_en,
    input logic exe_mem_reg_en,
    input logic mem_wb_reg_en,
    input logic pc_reg_en,


    // memory bus 
    output logic [31:0] mem_addr_mem, 
    output logic [31:0] mem_wdata_mem, 
    output logic [2:0] mem_op_mem,
    input logic [31:0] mem_rdata_mem,
    output logic mem_write_mem,
    output logic mem_to_reg_mem,

    // inst mem access
    output logic [31:0] current_pc_if,
    input logic [31:0] inst_if
);
    
    logic [31:0] inst_id;
    logic [31:0] current_pc, current_pc_id, current_pc_exe, current_pc_mem;
    logic [31:0] reg_rdata1_id, reg_rdata1_exe;
    logic [31:0] reg_rdata2_id, reg_rdata2_exe;
    logic [31:0] reg_wdata_wb;
    logic [31:0] imm_id,imm_exe, imm_mem, imm_wb;
    logic [31:0] pc_plus_4_if1, pc_plus_4_id, pc_plus_4_exe, pc_plus_4_mem,pc_plus_4_wb;
    logic [31:0] pc_jump_exe, pc_jump_mem;
    logic [31:0] next_pc_if1;
    logic [31:0] non_mem_result_wb;


    logic reg_write_exe;
    logic mem_write_exe;
    logic branch_exe;
    logic jump_exe, jump_wb;
    logic lui_exe, lui_mem, lui_wb;
    logic auipc_exe, auipc_mem, auipc_wb;
    logic jal_exe, jal_mem, jal_wb;
    logic zero_exe;
    logic mem_to_reg_wb;
    logic [31:0] alu_result_exe, alu_result_mem;
    logic [31:0] result_mem;
    logic [31:0] rdata2_frw_mem;
    logic [31:0] current_pc_if1;
    logic [31:0] current_pc_if2, pc_plus_4_if2, inst_if2;

 
    program_counter PC_inst (
        .*,
        .en(pc_reg_en)
    );


    // pc adder 
    assign pc_plus_4_if1 = current_pc_if1 + 4;

    mux2x1 #(
        .n(32)
    ) next_pc_mux (
        .sel(pc_sel_mem),
        .in0(pc_plus_4_if1),
        .in1(pc_jump_mem),
        .out(next_pc_if1)
    );

    assign current_pc_if = current_pc_if1;

    // ============================================
    //              IF1-IF2 Pipeline Register
    // ============================================
    
    logic if_id_reg_en_ff;
    logic if_id_reg_clr_ff;
    n_bit_reg #(
        .n(1)
    ) if_id_reg_en_ff_inst (
        .*,
        .data_i(if_id_reg_en),
        .data_o(if_id_reg_en_ff),
        .wen(1'b1)
    );
    n_bit_reg #(
        .n(1)
    ) if_id_reg_clr_ff_inst (
        .*,
        .data_i(if_id_reg_clr),
        .data_o(if_id_reg_clr_ff),
        .wen(1'b1)
    );


    if1_if2_reg_t if1_if2_bus_i, if1_if2_bus_o;

    assign if1_if2_bus_i = {
        current_pc_if1,
        pc_plus_4_if1
    };

    n_bit_reg_wclr #(
        .n($bits(if1_if2_reg_t)) // Automatically sets width
    ) if1_if2_reg (
        .clk(clk),
        .reset_n(reset_n),
        .clear(if_id_reg_clr),
        .wen(if_id_reg_en),
        .data_i(if1_if2_bus_i),
        .data_o(if1_if2_bus_o)
    );

    assign current_pc_if2  = if1_if2_bus_o.current_pc;
    assign pc_plus_4_if2   = if1_if2_bus_o.pc_plus_4;

    logic [31:0] inst_if_ff;

    n_bit_reg_wclr #(
        .n(32),
        .CLR_VALUE(32'h00000013)
    ) if2_reg (
        .*,
        .data_i(inst_if),
        .data_o(inst_if_ff),
        .wen(if_id_reg_en_ff),
        .clear(if_id_reg_clr)
    );
    assign inst_if2 = if_id_reg_en_ff ? inst_if : inst_if_ff;


    // ============================================
    //              IF-ID Pipeline Register
    // ============================================
    
    if_id_reg_t if_id_bus_i, if_id_bus_o;

    assign if_id_bus_i = {
        current_pc_if2,
        pc_plus_4_if2,
        inst_if2
    };

    n_bit_reg_wclr #(
        .n($bits(if_id_reg_t)) // Automatically sets width
    ) if_id_reg (
        .clk(clk),
        .reset_n(reset_n),
        .clear(if_id_reg_clr | if_id_reg_clr_ff),
        .wen(if_id_reg_en),
        .data_i(if_id_bus_i),
        .data_o(if_id_bus_o)
    );

    assign current_pc_id  = if_id_bus_o.current_pc;
    assign pc_plus_4_id   = if_id_bus_o.pc_plus_4;
    assign inst_id        = if_id_bus_o.inst;


    // ============================================
    //                Decode Stage 
    // ============================================


    // Giving descriptive names to field of instructions 
    logic [4:0] rd_id;
    logic [6:0] fun7_id;
    logic [2:0] fun3_id;

    assign rs1_id    = inst_id[19:15];
    assign rs2_id    = inst_id[24:20];
    assign rd_id     = inst_id[11:7] ;
    assign fun3_id   = inst_id[14:12];
    assign fun7_id   = inst_id[31:25];
    assign opcode_id = inst_id[6:0];
    assign fun7_5_id = fun7_id[5];

    logic [31:0] reg_rdata1, reg_rdata2;
    

    // register file (decode stage)
    reg_file reg_file_inst (
        .clk         (clk        ),
        .reset_n     (reset_n    ),
        .reg_write   (reg_write_wb),
        .raddr1      (rs1_id),
        .raddr2      (rs2_id),
        .waddr       (rd_wb),
        .wdata       (reg_wdata_wb),
        .rdata1      (reg_rdata1),
        .rdata2      (reg_rdata2)
    );


    // Immediate unit (decode stage_)
    imm_gen imm_gen_inst (
        .inst(inst_id),
        .j_type(jal_id),
        .b_type(branch_id),
        .s_type(mem_write_id),
        .lui(lui_id),
        .auipc(auipc_id),
        .imm(imm_id)
    );

   // forwarding mux for rd1 (decode stage)
    mux2x1 #(32) reg_file_rd1_mux (
        .sel(forward_rd1_id),
        .in0(reg_rdata1),
        .in1(reg_wdata_wb),
        .out(reg_rdata1_id)
    );

    // forwarding mux for rd2 (decode stage)
    mux2x1 #(32) reg_file_rd2_mux (
        .sel(forward_rd2_id),
        .in0(reg_rdata2),
        .in1(reg_wdata_wb),
        .out(reg_rdata2_id)
    );  


    // ============================================
    //             ID-EXE Pipeline Register
    // ============================================
    
    id_exe_reg_t id_exe_bus_i, id_exe_bus_o;

    assign id_exe_bus_i = {
        // data signals 
        current_pc_id, // 32
        pc_plus_4_id,  // 32
        rs1_id,        // 32
        rs2_id,
        rd_id, 
        fun3_id,
        fun7_5_id,
        reg_rdata1_id,
        reg_rdata2_id,
        imm_id,
        // control signals
        reg_write_id,
        mem_write_id,
        mem_to_reg_id, 
        branch_id,
        alu_src_id,
        jump_id,
        lui_id,
        auipc_id,
        jal_id,
        alu_op_id
    };

    n_bit_reg_wclr #(
        .n($bits(id_exe_reg_t))
    ) id_exe_reg (
        .clk(clk),
        .reset_n(reset_n),
        .clear(id_exe_reg_clr),
        .wen(id_exe_reg_en),
        .data_i(id_exe_bus_i),
        .data_o(id_exe_bus_o)
    );

    // data signals 
    assign current_pc_exe  = id_exe_bus_o.current_pc; // 32
    assign pc_plus_4_exe   = id_exe_bus_o.pc_plus_4;  // 32
    assign rs1_exe         = id_exe_bus_o.rs1;     // 5
    assign rs2_exe         = id_exe_bus_o.rs2;
    assign rd_exe          = id_exe_bus_o.rd; 
    assign fun3_exe        = id_exe_bus_o.fun3;
    assign fun7_5_exe      = id_exe_bus_o.fun7_5;
    assign reg_rdata1_exe  = id_exe_bus_o.reg_rdata1;
    assign reg_rdata2_exe  = id_exe_bus_o.reg_rdata2;
    assign imm_exe         = id_exe_bus_o.imm;

    // control signals
    assign reg_write_exe   = id_exe_bus_o.reg_write;
    assign mem_write_exe   = id_exe_bus_o.mem_write;
    assign mem_to_reg_exe  = id_exe_bus_o.mem_to_reg;
    assign branch_exe      = id_exe_bus_o.branch;
    assign alu_src_exe     = id_exe_bus_o.alu_src;
    assign jump_exe        = id_exe_bus_o.jump;
    assign lui_exe         = id_exe_bus_o.lui; 
    assign auipc_exe       = id_exe_bus_o.auipc;
    assign jal_exe         = id_exe_bus_o.jal;
    assign alu_op_exe      = id_exe_bus_o.alu_op;



    // ============================================
    //                Execute Stage 
    // ============================================


    // forwarding multiplexers
    wire [31:0] rdata1_frw_exe, rdata2_frw_exe;
    // Forwarding mux for rd1
    mux3x1 #(32) forwarding_mux_a (
        .sel(forward_rd1_exe),
        .in0(reg_rdata1_exe),
        .in1(result_mem),
        .in2(reg_wdata_wb),
        .out(rdata1_frw_exe)
    );

    // Forwarding mux for rd2
    mux3x1 #(32) forwarding_mux_b (
        .sel(forward_rd2_exe),
        .in0(reg_rdata2_exe),
        .in1(result_mem),
        .in2(reg_wdata_wb),
        .out(rdata2_frw_exe)
    );      


    // jalr multiplexer
    logic jalr_exe;
    assign jalr_exe = ~jal_exe & jump_exe;
    logic [31:0] jump_base_pc_exe;
    mux2x1 #(
        .n(32)
    ) jalr_pc_mux (
        .sel(jalr_exe), // jalr means jump to ([rs1] + imm)
        .in0(current_pc_exe), // all other (pc + imm)
        .in1(rdata1_frw_exe),
        .out(jump_base_pc_exe)
    );

    assign pc_jump_exe = jump_base_pc_exe + imm_exe;



    // multiplxers at alu inputs (exe stage)
    logic [31:0] alu_op1_exe;
    logic [31:0] alu_op2_exe;
    mux2x1 #(
        .n(32)
    ) alu_op1_mux (
        .sel(auipc_exe),
        .in0(rdata1_frw_exe),
        .in1(current_pc_exe),
        .out(alu_op1_exe)       
    );

    // (exe stage)
    mux2x1 #(
        .n(32)
    ) alu_op2_mux (
        .sel(alu_src_exe),
        .in0(rdata2_frw_exe),
        .in1(imm_exe),
        .out(alu_op2_exe)       
    );



    // instantiating the ALU here (exe_stage)
    alu alu_inst (
        .alu_ctrl(alu_t'(alu_ctrl_exe)),
        .op1(alu_op1_exe),
        .op2(alu_op2_exe),
        .alu_result(alu_result_exe), 
        .zero(zero_exe)
    );


    // ============================================
    //           EXE-MEM Pipeline Register
    // ============================================
    
    exe_mem_reg_t exe_mem_bus_i, exe_mem_bus_o;

    assign exe_mem_bus_i = {
    // data signals 
    pc_plus_4_exe,  
    pc_jump_exe,     
    rs2_exe,
    rd_exe, 
    fun3_exe,
    rdata2_frw_exe,
    imm_exe,
    alu_result_exe,
    // control signals
    reg_write_exe,
    mem_write_exe,
    mem_to_reg_exe, 
    branch_exe,
    jump_exe,
    lui_exe,
    zero_exe
    };

    n_bit_reg_wclr #(
        .n($bits(exe_mem_reg_t))
    ) exe_mem_reg (
        .clk(clk),
        .reset_n(reset_n),
        .clear(exe_mem_reg_clr),
        .wen(exe_mem_reg_en),
        .data_i(exe_mem_bus_i),
        .data_o(exe_mem_bus_o)
    );

    // data signals 
    assign pc_plus_4_mem   = exe_mem_bus_o.pc_plus_4;  // 32
    assign pc_jump_mem     = exe_mem_bus_o.pc_jump;
    assign rs2_mem         = exe_mem_bus_o.rs2;
    assign rd_mem          = exe_mem_bus_o.rd; 
    assign fun3_mem        = exe_mem_bus_o.fun3;
    assign rdata2_frw_mem  = exe_mem_bus_o.rdata2_frw;
    assign imm_mem         = exe_mem_bus_o.imm;
    assign alu_result_mem  = exe_mem_bus_o.alu_result;
    // control signals
    assign reg_write_mem   = exe_mem_bus_o.reg_write;
    assign mem_write_mem   = exe_mem_bus_o.mem_write;
    assign mem_to_reg_mem  = exe_mem_bus_o.mem_to_reg;
    assign branch_mem      = exe_mem_bus_o.branch;
    assign jump_mem        = exe_mem_bus_o.jump;
    assign lui_mem         = exe_mem_bus_o.lui; 
    assign zero_mem        = exe_mem_bus_o.zero;


    // ============================================
    //                Memory Stage 
    // ============================================
    
    // generating memory access signals (write/read) 
   
    // forwarding for mem_write_data
    mux2x1 #(32) mem_data_in_mux (
        .sel(forward_rd2_mem),
        .in0(rdata2_frw_mem),
        .in1(reg_wdata_wb),
        .out(mem_wdata_mem)
    );    
    assign mem_addr_mem = alu_result_mem;
    assign mem_op_mem = fun3_mem;
    

    // selecting result in the memory stage
    // it can be used in the exe, incase it's needed 

    logic alu_to_reg_mem;
    assign alu_to_reg_mem = ~( jump_mem | lui_mem);
    one_hot_mux3x1 #(
        .n(32)
    ) mem_stage_result_sel_mux (
        .sel({lui_mem, jump_mem, alu_to_reg_mem}),
        .in0(alu_result_mem),
        .in1(pc_plus_4_mem),
        .in2(imm_mem),
        .out(result_mem)
    );

    // ============================================
    //            MEM-WB Pipeline Register
    // ============================================
    
    mem_wb_reg_t mem_wb_bus_i, mem_wb_bus_o;
    logic [31:0] alu_mem_result_wb;

    assign mem_wb_bus_i = {
    // data signals 
    rd_mem, 
    result_mem,
    // control signals
    reg_write_mem,
    mem_to_reg_mem
    };

    n_bit_reg_wclr #(
        .n($bits(mem_wb_reg_t))
    ) mem_wb_reg (
        .clk(clk),
        .reset_n(reset_n),
        .clear(mem_wb_reg_clr),
        .wen(mem_wb_reg_en),
        .data_i(mem_wb_bus_i),
        .data_o(mem_wb_bus_o)
    );

    // data signals 
    assign rd_wb             = mem_wb_bus_o.rd; 
    assign non_mem_result_wb = mem_wb_bus_o.result;
    // control signals
    assign reg_write_wb      = mem_wb_bus_o.reg_write;
    assign mem_to_reg_wb     = mem_wb_bus_o.mem_to_reg; 


    // ============================================
    //                Write Back Stage 
    // ============================================

    logic [31:0] mem_rdata_wb;
    assign mem_rdata_wb = mem_rdata_mem;

    mux2x1 #(
        .n(32)
    ) write_back_mux (
        .sel(mem_to_reg_wb),
        .in0(non_mem_result_wb),
        .in1(mem_rdata_wb),
        .out(reg_wdata_wb)
    );

endmodule 