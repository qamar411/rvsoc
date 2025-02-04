module rv32i_soc #(
    parameter DMEM_DEPTH = 4096,
    parameter IMEM_DEPTH = 4096
) (
    input logic clk, 
    input logic reset_n,

    // spi signals to the spi-flash
    output logic       o_flash_sclk,     // serial clock output
    output logic       o_flash_cs_n,     // slave select (active low)
    output logic       o_flash_mosi,     // MasterOut SlaveIN
    input  logic       i_flash_miso,     // MasterIn SlaveOut    

    // uart signals
    output logic        o_uart_tx,
    input logic         i_uart_rx,

    // gpio signals

    inout wire [31:0]   io_data
    // signals to the spi

    // 
);


    // Memory bus signals
    logic [31:0] mem_addr_mem;
    logic [31:0] mem_wdata_mem; 
    logic        mem_write_mem;
    logic [2:0]  mem_op_mem;
    logic [31:0] mem_rdata_mem;
    logic        mem_read_mem;

    logic [31:0] dmem_rdata, spi_rdata;
    logic dmem_write, spi_write, spi_read;
    logic stall_pipl;
    logic [31:0] current_pc, inst;
    logic sel_boot_rom;
    logic if_id_reg_en;

    // Processor core instance
    rv32i #(
        .DMEM_DEPTH(DMEM_DEPTH),
        .IMEM_DEPTH(IMEM_DEPTH)
    ) rv32i_core_inst (
        .*
    );

    logic wb_cyc;
    logic wb_stb;
    logic [31:0] wb_adr;
    logic [31:0] wb_wdata;
    logic [31:0] wb_rdata;
    logic wb_ack;
    logic wb_we;
    logic [3:0] wb_sel;


    wire   wb_clk;
    wire   wb_rst;
    assign wb_clk = clk;
    assign wb_rst = ~reset_n;

    // Wishbone Master
    // `include "soc/WishboneInterconnect/wb_intercon.svh"  // for VCS
    `include "/home/it/Documents/rvsoc_v3/src/soc/WishboneInterconnect/wb_intercon.svh" // for FPGA prototyping
    

        wishbone_controller wishbone_master (
        .clk        (clk),
        .rst        (~reset_n),
        .proc_addr  (mem_addr_mem),
        .proc_wdata (mem_wdata_mem),
        .proc_write (mem_write_mem),
        .proc_read  (mem_read_mem),
        .proc_op    (mem_op_mem),
        .proc_rdata (mem_rdata_mem),
        .proc_stall_pipl(stall_pipl), // Stall pipeline if needed
        .wb_adr_o   (wb_m2s_io_adr),     // Connect to the external Wishbone bus as required
        .wb_dat_o   (wb_m2s_io_dat),
        .wb_sel_o   (wb_m2s_io_sel),
        .wb_we_o    (wb_m2s_io_we ),
        .wb_cyc_o   (wb_m2s_io_cyc),
        .wb_stb_o   (wb_m2s_io_stb),
        .wb_dat_i   (wb_s2m_io_dat), // For simplicity, no data input
        .wb_ack_i   (wb_s2m_io_ack)   // For simplicity, no acknowledgment signal
    );
    assign wb_m2s_io_cti = 0;
    assign wb_m2s_io_bte  = 0;

    // wishbone interconnect, // later we should use interfaces to reduces number of lines
    wb_intercon wb_intercon0
   (.wb_clk_i           (wb_clk),
    .wb_rst_i           (wb_rst),
    .wb_io_adr_i        (wb_m2s_io_adr),
    .wb_io_dat_i        (wb_m2s_io_dat),
    .wb_io_sel_i        (wb_m2s_io_sel),
    .wb_io_we_i         (wb_m2s_io_we),
    .wb_io_cyc_i        (wb_m2s_io_cyc),
    .wb_io_stb_i        (wb_m2s_io_stb),
    .wb_io_cti_i        (wb_m2s_io_cti),
    .wb_io_bte_i        (wb_m2s_io_bte),
    .wb_io_dat_o        (wb_s2m_io_dat),
    .wb_io_ack_o        (wb_s2m_io_ack),
    .wb_io_err_o        (wb_s2m_io_err),
    .wb_io_rty_o        (wb_s2m_io_rty),


    // .wb_rom_adr_o       (wb_m2s_rom_adr),
    // .wb_rom_dat_o       (wb_m2s_rom_dat),
    // .wb_rom_sel_o       (wb_m2s_rom_sel),
    // .wb_rom_we_o        (wb_m2s_rom_we),
    // .wb_rom_cyc_o       (wb_m2s_rom_cyc),
    // .wb_rom_stb_o       (wb_m2s_rom_stb),
    // .wb_rom_cti_o       (wb_m2s_rom_cti),
    // .wb_rom_bte_o       (wb_m2s_rom_bte),
    // .wb_rom_dat_i       (wb_s2m_rom_dat),
    // .wb_rom_ack_i       (wb_s2m_rom_ack),
    // .wb_rom_err_i       (wb_s2m_rom_err),
    // .wb_rom_rty_i       (wb_s2m_rom_rty),


    .wb_spi_flash_adr_o (wb_m2s_spi_flash_adr),
    .wb_spi_flash_dat_o (wb_m2s_spi_flash_dat),
    .wb_spi_flash_sel_o (wb_m2s_spi_flash_sel),
    .wb_spi_flash_we_o  (wb_m2s_spi_flash_we),
    .wb_spi_flash_cyc_o (wb_m2s_spi_flash_cyc),
    .wb_spi_flash_stb_o (wb_m2s_spi_flash_stb),
    .wb_spi_flash_cti_o (wb_m2s_spi_flash_cti),
    .wb_spi_flash_bte_o (wb_m2s_spi_flash_bte),
    .wb_spi_flash_dat_i (wb_s2m_spi_flash_dat),
    .wb_spi_flash_ack_i (wb_s2m_spi_flash_ack),
    .wb_spi_flash_err_i (wb_s2m_spi_flash_err),
    .wb_spi_flash_rty_i (wb_s2m_spi_flash_rty),


    .wb_dmem_adr_o       (wb_m2s_dmem_adr),
    .wb_dmem_dat_o       (wb_m2s_dmem_dat),
    .wb_dmem_sel_o       (wb_m2s_dmem_sel),
    .wb_dmem_we_o        (wb_m2s_dmem_we),
    .wb_dmem_cyc_o       (wb_m2s_dmem_cyc),
    .wb_dmem_stb_o       (wb_m2s_dmem_stb),
    .wb_dmem_cti_o       (wb_m2s_dmem_cti),
    .wb_dmem_bte_o       (wb_m2s_dmem_bte),
    .wb_dmem_dat_i       (wb_s2m_dmem_dat),
    .wb_dmem_ack_i       (wb_s2m_dmem_ack),
    .wb_dmem_err_i       (wb_s2m_dmem_err),
    .wb_dmem_rty_i       (wb_s2m_dmem_rty),

    .wb_imem_adr_o       (wb_m2s_imem_adr),
    .wb_imem_dat_o       (wb_m2s_imem_dat),
    .wb_imem_sel_o       (wb_m2s_imem_sel),
    .wb_imem_we_o        (wb_m2s_imem_we),
    .wb_imem_cyc_o       (wb_m2s_imem_cyc),
    .wb_imem_stb_o       (wb_m2s_imem_stb),
    .wb_imem_cti_o       (wb_m2s_imem_cti),
    .wb_imem_bte_o       (wb_m2s_imem_bte),
    .wb_imem_dat_i       (wb_s2m_imem_dat),
    .wb_imem_ack_i       (wb_s2m_imem_ack),
    .wb_imem_err_i       (wb_s2m_imem_err),
    .wb_imem_rty_i       (wb_s2m_imem_rty),

    .wb_uart_adr_o      (wb_m2s_uart_adr),
    .wb_uart_dat_o      (wb_m2s_uart_dat),
    .wb_uart_sel_o      (wb_m2s_uart_sel),
    .wb_uart_we_o       (wb_m2s_uart_we),
    .wb_uart_cyc_o      (wb_m2s_uart_cyc),
    .wb_uart_stb_o      (wb_m2s_uart_stb),
    .wb_uart_cti_o      (wb_m2s_uart_cti),
    .wb_uart_bte_o      (wb_m2s_uart_bte),
    .wb_uart_dat_i      (wb_s2m_uart_dat),
    .wb_uart_ack_i      (wb_s2m_uart_ack),
    .wb_uart_err_i      (wb_s2m_uart_err),
    .wb_uart_rty_i      (wb_s2m_uart_rty),
// GPIO
    .wb_gpio_adr_o      (wb_m2s_gpio_adr),
    .wb_gpio_dat_o      (wb_m2s_gpio_dat),
    .wb_gpio_sel_o      (wb_m2s_gpio_sel),
    .wb_gpio_we_o       (wb_m2s_gpio_we),
    .wb_gpio_cyc_o      (wb_m2s_gpio_cyc),
    .wb_gpio_stb_o      (wb_m2s_gpio_stb),
    .wb_gpio_cti_o      (wb_m2s_gpio_cti),
    .wb_gpio_bte_o      (wb_m2s_gpio_bte),
    .wb_gpio_dat_i      (wb_s2m_gpio_dat),
    .wb_gpio_ack_i      (wb_s2m_gpio_ack),
    .wb_gpio_err_i      (wb_s2m_gpio_err),
    .wb_gpio_rty_i      (wb_s2m_gpio_rty));


   wire [7:0] 		       spi_rdt;
   assign wb_s2m_spi_flash_dat = {24'd0,spi_rdt};
   simple_spi spi
     (// Wishbone slave interface
      .clk_i  (clk),
      .rst_i  (wb_rst),
      .adr_i  (wb_m2s_spi_flash_adr[4:2]),
      .dat_i  (wb_m2s_spi_flash_dat[7:0]),
      .we_i   (wb_m2s_spi_flash_we),
      .cyc_i  (wb_m2s_spi_flash_cyc),
      .stb_i  (wb_m2s_spi_flash_stb),
      .dat_o  (spi_rdt),
      .ack_o  (wb_s2m_spi_flash_ack),
      .inta_o (),
      // SPI interface
      .sck_o  (o_flash_sclk),
      .ss_o   (o_flash_cs_n),
      .mosi_o (o_flash_mosi),
      .miso_i (i_flash_miso));
   
   assign wb_s2m_spi_flash_err = 1'b0;
   assign wb_s2m_spi_flash_rty = 1'b0;

   wire [7:0] 		       uart_rdt;
   assign wb_s2m_uart_dat = {24'd0, uart_rdt};
   assign wb_s2m_uart_err = 1'b0;
   assign wb_s2m_uart_rty = 1'b0;

   uart_top uart16550_0
     (// Wishbone slave interface

      .wb_clk_i	(clk),
      .wb_rst_i	(~reset_n),
      .wb_adr_i	(wb_m2s_uart_adr[4:2]),
      .wb_dat_i	(wb_m2s_uart_dat[7:0]),
      .wb_we_i	(wb_m2s_uart_we),
      .wb_cyc_i	(wb_m2s_uart_cyc),
      .wb_stb_i	(wb_m2s_uart_stb),
      .wb_sel_i	(4'b0), // Not used in 8-bit mode
      .wb_dat_o	(uart_rdt),
      .wb_ack_o	(wb_s2m_uart_ack),

      // Outputs
      .int_o     (),
      .stx_pad_o (o_uart_tx),
      .rts_pad_o (),
      .dtr_pad_o (),

      // Inputs
      .srx_pad_i (i_uart_rx),
      .cts_pad_i (1'b0),
      .dsr_pad_i (1'b0),
      .ri_pad_i  (1'b0),
      .dcd_pad_i (1'b0));

   // GPIO - Leds and Switches
   wire [31:0] en_gpio;
   wire        gpio_irq;

   wire [31:0] i_gpio;
   wire [31:0] o_gpio;

   genvar i;
   generate
        for( i = 0; i<32; i = i+1) 
        begin:gpio_gen_loop
            bidirec gpio1  (.oe(en_gpio[i] ), .inp(o_gpio[i] ), .outp(i_gpio[i] ), .bidir(io_data[i] ));
        end    
   endgenerate

    // assign i_gpio = {16'd0,io_data[31:16]};
    // assign io_data[15:0] = o_gpio[15:0];

   gpio_top gpio_module(
        .wb_clk_i     (clk), 
        .wb_rst_i     (wb_rst), 
        .wb_cyc_i     (wb_m2s_gpio_cyc), 
        .wb_adr_i     ({2'b0,wb_m2s_gpio_adr[5:2],2'b0}), 
        .wb_dat_i     (wb_m2s_gpio_dat), 
        .wb_sel_i     (4'b1111),
        .wb_we_i      (wb_m2s_gpio_we), 
        .wb_stb_i     (wb_m2s_gpio_stb), 
        .wb_dat_o     (wb_s2m_gpio_dat),
        .wb_ack_o     (wb_s2m_gpio_ack), 
        .wb_err_o     (wb_s2m_gpio_err),
        .wb_inta_o    (gpio_irq),
        // gpio signals 
        .i_gpio(i_gpio),
        .o_gpio(o_gpio),
        .en_gpio(en_gpio)
        );

    // ============================================
    //             Data Memory Instance
    // ============================================

    data_mem #(
        .DEPTH(DMEM_DEPTH)
    ) data_mem_inst (
        .clk_i       (clk            ),
        .rst_i       (wb_rst         ),
        .cyc_i       (wb_m2s_dmem_cyc), 
        .stb_i       (wb_m2s_dmem_stb),
        .adr_i       (wb_m2s_dmem_adr),
        .we_i        (wb_m2s_dmem_we ),
        .sel_i       (wb_m2s_dmem_sel),
        .dat_i       (wb_m2s_dmem_dat),
        .dat_o       (wb_s2m_dmem_dat),
        .ack_o       (wb_s2m_dmem_ack)
    );


    // ============================================
    //          Instruction Memory Instance
    // ============================================

    logic [31:0] imem_inst;

    logic [31:0] imem_addr;
    
    assign imem_addr = sel_boot_rom ? wb_m2s_dmem_adr: current_pc;

    data_mem #(
        .DEPTH(IMEM_DEPTH)
    ) inst_mem_inst (
        .clk_i       (clk            ),
        .rst_i       (wb_rst         ),
        .cyc_i       (wb_m2s_imem_cyc), 
        .stb_i       (wb_m2s_imem_stb),
        .adr_i       (imem_addr      ),
        .we_i        (wb_m2s_imem_we ),
        .sel_i       (wb_m2s_imem_sel),
        .dat_i       (wb_m2s_imem_dat),
        .dat_o       (wb_s2m_imem_dat),
        .ack_o       (wb_s2m_imem_ack)
    );

    assign imem_inst = wb_s2m_dmem_dat;

    // ============================================
    //            SRAM Memory Instances
    // ============================================    


//  // for read, acnolwedge should be delayed by a cycle
//     // for write aknolwedge should be given in the same cycle
//     logic imem_access, imem_read_access_ff;
//     logic dmem_access, dmem_read_access_ff;
//     logic imem_read_ack;
//     logic imem_write_ack;
//     logic dmem_read_ack;
//     logic dmem_write_ack;

//     assign imem_access = wb_m2s_imem_cyc & wb_m2s_imem_stb;
//     assign dmem_access = wb_m2s_dmem_cyc & wb_m2s_dmem_stb;

    

//     // DMEM signals
//     logic dmem_CLK;
//     logic [14:0] dmem_A;
//     logic dmem_CEB;
//     logic dmem_OEB;
//     logic dmem_GWEB;
//     logic dmem_BWEB;
//     logic [3:0] dmem_BWB;
//     logic [31:0] dmem_DIN;
//     logic [31:0] dmem_DOUT;
//     // DMEM connections (example)
//     assign dmem_CLK = clk;  // Connect the main clock
//     assign dmem_A = wb_m2s_dmem_adr[16:2];
//     assign dmem_CEB = ~dmem_access;
//     assign dmem_GWEB = 1'b1;
//     assign dmem_OEB = ~(dmem_access & ~wb_m2s_dmem_we);
//     assign dmem_BWEB = ~(wb_m2s_dmem_we & dmem_access);
//     assign dmem_BWB = ~{4{wb_m2s_dmem_we}} | ~wb_m2s_dmem_sel;
//     assign dmem_DIN = wb_m2s_dmem_dat;
//     assign wb_s2m_dmem_dat = dmem_DOUT;  // Read from DMEM



//    // IMEM signals
//     logic imem_CLK;
//     logic [14:0] imem_A;
//     logic imem_CEB;
//     logic imem_OEB;
//     logic imem_GWEB;
//     logic imem_BWEB;
//     logic [3:0] imem_BWB;
//     logic [31:0] imem_DIN;
//     logic [31:0] imem_DOUT;



//     // DMEM from TSMC
//     TS1DA32KX32 data_mem_inst (
//         .CLK(dmem_CLK),
//         .A(dmem_A),
//         .CEB(dmem_CEB),
//         .OEB(dmem_OEB),
//         .GWEB(dmem_GWEB),
//         .BWEB(dmem_BWEB),
//         .BWB(dmem_BWB),
//         .DIN(dmem_DIN),
//         .DOUT(dmem_DOUT)
//     );

//     logic [16:0] imem_addr;
//     logic [31:0] imem_inst;

//     mux2x1 #(
//         .n(17)
//     ) imem_sel_mux (
//         .in1    (wb_m2s_imem_adr[16:0]),
//         .in0    (current_pc[16:0]             ),
//         .sel    (sel_boot_rom),
//         .out    (imem_addr   )
//     );

//     // IMEM connections (example)
//     assign imem_CLK = clk;  // Connect the main clock
//     assign imem_A = imem_addr[16:2];
//     assign imem_CEB = ~imem_access;
//     assign imem_GWEB = 1'b1;
//     assign imem_OEB = ~(imem_access & ~wb_m2s_imem_we);
//     assign imem_BWEB = ~(wb_m2s_imem_we & imem_access);
//     assign imem_BWB =  ~{4{wb_m2s_imem_we}} | ~wb_m2s_imem_sel;
//     assign imem_DIN = wb_m2s_imem_dat;
//     assign wb_s2m_imem_dat = imem_DOUT;  // Read from IMEM

//     // IMEM from TSMC
//     TS1DA32KX32 inst_mem_inst (
//         .CLK(imem_CLK),
//         .A(imem_A),
//         .CEB(imem_CEB),
//         .OEB(imem_OEB),
//         .GWEB(imem_GWEB),
//         .BWEB(imem_BWEB),
//         .BWB(imem_BWB),
//         .DIN(imem_DIN),
//         .DOUT(imem_DOUT)
//     );

//     n_bit_reg #(
//         .n(1)
//     ) imem_access_dff (
//         .clk(clk),
//         .reset_n(reset_n),
//         .wen(1'b1),
//         .data_i(imem_access  & ~wb_m2s_imem_we),
//         .data_o(imem_read_access_ff)
//     );

//     n_bit_reg #(
//         .n(1)
//     ) dmem_access_dff (
//         .clk(clk),
//         .reset_n(reset_n),
//         .wen(1'b1),
//         .data_i(dmem_access & ~wb_m2s_dmem_we),
//         .data_o(dmem_read_access_ff)
//     );

//     assign imem_read_ack = imem_read_access_ff & imem_access & ~wb_m2s_imem_we;
//     assign imem_write_ack = imem_access;

//     assign dmem_read_ack = dmem_read_access_ff & dmem_access & ~wb_m2s_dmem_we;
//     assign dmem_write_ack = dmem_access;

//     assign wb_s2m_imem_ack = wb_m2s_imem_we? imem_write_ack : imem_read_ack;
//     assign wb_s2m_dmem_ack = wb_m2s_dmem_we? dmem_write_ack : dmem_read_ack;
//     assign imem_inst = wb_m2s_imem_dat;




    // BOOT ROM 

    logic [31:0] rom_inst, rom_inst_ff;
    rom rom_instance(
        .addr     (current_pc[11:0]),
        .inst     (rom_inst  )
    );

    // register after boot rom (to syncronize with the pipeline and inst mem)
    n_bit_reg #(
        .n(32)
    ) rom_inst_reg (
        .clk(clk),
        .reset_n(reset_n),
        .data_i(rom_inst),
        .data_o(rom_inst_ff),
        .wen(if_id_reg_en)
    );



    // Inst selection mux
    assign sel_boot_rom = &current_pc[31:12]; // 0xfffff000 - to - 0xffffffff 
    mux2x1 #(
        .n(32)
    ) rom_imem_inst_sel_mux (
        .in0    (imem_inst   ),
        .in1    (rom_inst_ff ),
        .sel    (sel_boot_rom),
        .out    (inst        )
    );


    
endmodule : rv32i_soc