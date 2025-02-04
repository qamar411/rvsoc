//module imem #(
//    parameter DEPTH = 1024
//)(
//  // 8bit WISHBONE bus slave interface
//  input  wire        clk_i,         // clock
//  input  wire        rst_i,         // reset (synchronous active high)
//  input  wire        cyc_i,         // cycle
//  input  wire        stb_i,         // strobe
//  input  wire [31:0] adr_i,         // address
//  input  wire        we_i,          // write enable
//  input  wire [3:0]  sel_i,
//  input  wire [31:0] dat_i,         // data input
//  output reg  [31:0] dat_o,         // data output
//  output reg         ack_o,         // normal bus termination

//);
    
       
//logic wb_acc;
//logic mem_write, mem_read;
//logic [31:0] addr;

//assign wb_acc = cyc_i & stb_i;
//assign mem_write = wb_acc &  we_i;
//assign mem_read  = wb_acc & ~we_i;

//// outputs 
//// generate acknoledge one cycle after the reset
//n_bit_reg #(
//    .n(1)
//) wb_ac_ff (
//    .clk(clk),
//    .reset_n(reset_n),
//    .data_i(wb_acc),
//    .data_o(ack_o),
//    .wen(1'b1)
//);


//logic [6:0] word_addr;
//assign word_addr = adr_i[8:2];

//// inst memory here 
//logic [31:0] imem [0:DEPTH - 1];

//always_ff @(posedge clk_i) begin 
//    if(mem_write) begin 
//        if(sel_i[0]) imem[word_addr][7:0]   <= dat_i[7:0];
//        if(sel_i[1]) imem[word_addr][15:8]  <= dat_i[15:8];
//        if(sel_i[2]) imem[word_addr][23:16] <= dat_i[23:16];
//        if(sel_i[3]) imem[word_addr][31:24] <= dat_i[31:24];
//    end
//end

//logic [31:0] data_o_reg;
//n_bit_reg #(
//    .n(1)
//) data_o_reg (
//    .clk(clk),
//    .reset_n(reset_n),
//    .data_i(data_o),
//    .data_o(data_o_reg),
//    .wen(1'b1)
//);

//assign data_o = data_o_reg;

//endmodule
