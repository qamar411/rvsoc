// IO
wire [31:0] wb_m2s_io_adr;
wire [31:0] wb_m2s_io_dat;
wire  [3:0] wb_m2s_io_sel;
wire        wb_m2s_io_we;
wire        wb_m2s_io_cyc;
wire        wb_m2s_io_stb;
wire  [2:0] wb_m2s_io_cti;
wire  [1:0] wb_m2s_io_bte;
wire [31:0] wb_s2m_io_dat;
wire        wb_s2m_io_ack;
wire        wb_s2m_io_err;
wire        wb_s2m_io_rty;


// // ROM
// wire [31:0] wb_m2s_rom_adr;
// wire [31:0] wb_m2s_rom_dat;
// wire  [3:0] wb_m2s_rom_sel;
// wire        wb_m2s_rom_we;
// wire        wb_m2s_rom_cyc;
// wire        wb_m2s_rom_stb;
// wire  [2:0] wb_m2s_rom_cti;
// wire  [1:0] wb_m2s_rom_bte;
// wire [31:0] wb_s2m_rom_dat;
// wire        wb_s2m_rom_ack;
// wire        wb_s2m_rom_err;
// wire        wb_s2m_rom_rty;


// SPI FLASH
wire [31:0] wb_m2s_spi_flash_adr;
wire [31:0] wb_m2s_spi_flash_dat;
wire  [3:0] wb_m2s_spi_flash_sel;
wire        wb_m2s_spi_flash_we;
wire        wb_m2s_spi_flash_cyc;
wire        wb_m2s_spi_flash_stb;
wire  [2:0] wb_m2s_spi_flash_cti;
wire  [1:0] wb_m2s_spi_flash_bte;
wire [31:0] wb_s2m_spi_flash_dat;
wire        wb_s2m_spi_flash_ack;
wire        wb_s2m_spi_flash_err;
wire        wb_s2m_spi_flash_rty;


// // SYSTEM CONTROLLER
// wire [31:0] wb_m2s_sys_adr;
// wire [31:0] wb_m2s_sys_dat;
// wire  [3:0] wb_m2s_sys_sel;
// wire        wb_m2s_sys_we;
// wire        wb_m2s_sys_cyc;
// wire        wb_m2s_sys_stb;
// wire  [2:0] wb_m2s_sys_cti;
// wire  [1:0] wb_m2s_sys_bte;
// wire [31:0] wb_s2m_sys_dat;
// wire        wb_s2m_sys_ack;
// wire        wb_s2m_sys_err;
// wire        wb_s2m_sys_rty;

// UART
wire [31:0] wb_m2s_uart_adr;
wire [31:0] wb_m2s_uart_dat;
wire  [3:0] wb_m2s_uart_sel;
wire        wb_m2s_uart_we;
wire        wb_m2s_uart_cyc;
wire        wb_m2s_uart_stb;
wire  [2:0] wb_m2s_uart_cti;
wire  [1:0] wb_m2s_uart_bte;
wire [31:0] wb_s2m_uart_dat;
wire        wb_s2m_uart_ack;
wire        wb_s2m_uart_err;
wire        wb_s2m_uart_rty;

// GPIO
wire [31:0] wb_m2s_gpio_adr;
wire [31:0] wb_m2s_gpio_dat;
wire  [3:0] wb_m2s_gpio_sel;
wire        wb_m2s_gpio_we;
wire        wb_m2s_gpio_cyc;
wire        wb_m2s_gpio_stb;
wire  [2:0] wb_m2s_gpio_cti;
wire  [1:0] wb_m2s_gpio_bte;
wire [31:0] wb_s2m_gpio_dat;
wire        wb_s2m_gpio_ack;
wire        wb_s2m_gpio_err;
wire        wb_s2m_gpio_rty;


// IMEM
wire [31:0] wb_m2s_imem_adr;
wire [31:0] wb_m2s_imem_dat;
wire  [3:0] wb_m2s_imem_sel;
wire        wb_m2s_imem_we;
wire        wb_m2s_imem_cyc;
wire        wb_m2s_imem_stb;
wire  [2:0] wb_m2s_imem_cti;
wire  [1:0] wb_m2s_imem_bte;
wire [31:0] wb_s2m_imem_dat;
wire        wb_s2m_imem_ack;
wire        wb_s2m_imem_err;
wire        wb_s2m_imem_rty;



// DMEM
wire [31:0] wb_m2s_dmem_adr;
wire [31:0] wb_m2s_dmem_dat;
wire  [3:0] wb_m2s_dmem_sel;
wire        wb_m2s_dmem_we;
wire        wb_m2s_dmem_cyc;
wire        wb_m2s_dmem_stb;
wire  [2:0] wb_m2s_dmem_cti;
wire  [1:0] wb_m2s_dmem_bte;
wire [31:0] wb_s2m_dmem_dat;
wire        wb_s2m_dmem_ack;
wire        wb_s2m_dmem_err;
wire        wb_s2m_dmem_rty;

// // PTC
// wire [31:0] wb_m2s_ptc_adr;
// wire [31:0] wb_m2s_ptc_dat;
// wire  [3:0] wb_m2s_ptc_sel;
// wire        wb_m2s_ptc_we;
// wire        wb_m2s_ptc_cyc;
// wire        wb_m2s_ptc_stb;
// wire  [2:0] wb_m2s_ptc_cti;
// wire  [1:0] wb_m2s_ptc_bte;
// wire [31:0] wb_s2m_ptc_dat;
// wire        wb_s2m_ptc_ack;
// wire        wb_s2m_ptc_err;
// wire        wb_s2m_ptc_rty;

// // SPI
// wire [31:0] wb_m2s_spi_accel_adr;
// wire [31:0] wb_m2s_spi_accel_dat;
// wire  [3:0] wb_m2s_spi_accel_sel;
// wire        wb_m2s_spi_accel_we;
// wire        wb_m2s_spi_accel_cyc;
// wire        wb_m2s_spi_accel_stb;
// wire  [2:0] wb_m2s_spi_accel_cti;
// wire  [1:0] wb_m2s_spi_accel_bte;
// wire [31:0] wb_s2m_spi_accel_dat;
// wire        wb_s2m_spi_accel_ack;
// wire        wb_s2m_spi_accel_err;
// wire        wb_s2m_spi_accel_rty;

// wb_intercon wb_intercon0
//    (.wb_clk_i           (wb_clk),
//     .wb_rst_i           (wb_rst),
//     .wb_io_adr_i        (wb_m2s_io_adr),
//     .wb_io_dat_i        (wb_m2s_io_dat),
//     .wb_io_sel_i        (wb_m2s_io_sel),
//     .wb_io_we_i         (wb_m2s_io_we),
//     .wb_io_cyc_i        (wb_m2s_io_cyc),
//     .wb_io_stb_i        (wb_m2s_io_stb),
//     .wb_io_cti_i        (wb_m2s_io_cti),
//     .wb_io_bte_i        (wb_m2s_io_bte),
//     .wb_io_dat_o        (wb_s2m_io_dat),
//     .wb_io_ack_o        (wb_s2m_io_ack),
//     .wb_io_err_o        (wb_s2m_io_err),
//     .wb_io_rty_o        (wb_s2m_io_rty),


//     // .wb_rom_adr_o       (wb_m2s_rom_adr),
//     // .wb_rom_dat_o       (wb_m2s_rom_dat),
//     // .wb_rom_sel_o       (wb_m2s_rom_sel),
//     // .wb_rom_we_o        (wb_m2s_rom_we),
//     // .wb_rom_cyc_o       (wb_m2s_rom_cyc),
//     // .wb_rom_stb_o       (wb_m2s_rom_stb),
//     // .wb_rom_cti_o       (wb_m2s_rom_cti),
//     // .wb_rom_bte_o       (wb_m2s_rom_bte),
//     // .wb_rom_dat_i       (wb_s2m_rom_dat),
//     // .wb_rom_ack_i       (wb_s2m_rom_ack),
//     // .wb_rom_err_i       (wb_s2m_rom_err),
//     // .wb_rom_rty_i       (wb_s2m_rom_rty),


//     .wb_spi_flash_adr_o (wb_m2s_spi_flash_adr),
//     .wb_spi_flash_dat_o (wb_m2s_spi_flash_dat),
//     .wb_spi_flash_sel_o (wb_m2s_spi_flash_sel),
//     .wb_spi_flash_we_o  (wb_m2s_spi_flash_we),
//     .wb_spi_flash_cyc_o (wb_m2s_spi_flash_cyc),
//     .wb_spi_flash_stb_o (wb_m2s_spi_flash_stb),
//     .wb_spi_flash_cti_o (wb_m2s_spi_flash_cti),
//     .wb_spi_flash_bte_o (wb_m2s_spi_flash_bte),
//     .wb_spi_flash_dat_i (wb_s2m_spi_flash_dat),
//     .wb_spi_flash_ack_i (wb_s2m_spi_flash_ack),
//     .wb_spi_flash_err_i (wb_s2m_spi_flash_err),
//     .wb_spi_flash_rty_i (wb_s2m_spi_flash_rty),


//     .wb_dmem_adr_o       (wb_m2s_dmem_adr),
//     .wb_dmem_dat_o       (wb_m2s_dmem_dat),
//     .wb_dmem_sel_o       (wb_m2s_dmem_sel),
//     .wb_dmem_we_o        (wb_m2s_dmem_we),
//     .wb_dmem_cyc_o       (wb_m2s_dmem_cyc),
//     .wb_dmem_stb_o       (wb_m2s_dmem_stb),
//     .wb_dmem_cti_o       (wb_m2s_dmem_cti),
//     .wb_dmem_bte_o       (wb_m2s_dmem_bte),
//     .wb_dmem_dat_i       (wb_s2m_dmem_dat),
//     .wb_dmem_ack_i       (wb_s2m_dmem_ack),
//     .wb_dmem_err_i       (wb_s2m_dmem_err),
//     .wb_dmem_rty_i       (wb_s2m_dmem_rty),

//     .wb_imem_adr_o       (wb_m2s_imem_adr),
//     .wb_imem_dat_o       (wb_m2s_imem_dat),
//     .wb_imem_sel_o       (wb_m2s_imem_sel),
//     .wb_imem_we_o        (wb_m2s_imem_we),
//     .wb_imem_cyc_o       (wb_m2s_imem_cyc),
//     .wb_imem_stb_o       (wb_m2s_imem_stb),
//     .wb_imem_cti_o       (wb_m2s_imem_cti),
//     .wb_imem_bte_o       (wb_m2s_imem_bte),
//     .wb_imem_dat_i       (wb_s2m_imem_dat),
//     .wb_imem_ack_i       (wb_s2m_imem_ack),
//     .wb_imem_err_i       (wb_s2m_imem_err),
//     .wb_imem_rty_i       (wb_s2m_imem_rty),

//     .wb_uart_adr_o      (wb_m2s_uart_adr),
//     .wb_uart_dat_o      (wb_m2s_uart_dat),
//     .wb_uart_sel_o      (wb_m2s_uart_sel),
//     .wb_uart_we_o       (wb_m2s_uart_we),
//     .wb_uart_cyc_o      (wb_m2s_uart_cyc),
//     .wb_uart_stb_o      (wb_m2s_uart_stb),
//     .wb_uart_cti_o      (wb_m2s_uart_cti),
//     .wb_uart_bte_o      (wb_m2s_uart_bte),
//     .wb_uart_dat_i      (wb_s2m_uart_dat),
//     .wb_uart_ack_i      (wb_s2m_uart_ack),
//     .wb_uart_err_i      (wb_s2m_uart_err),
//     .wb_uart_rty_i      (wb_s2m_uart_rty),
// // GPIO
//     .wb_gpio_adr_o      (wb_m2s_gpio_adr),
//     .wb_gpio_dat_o      (wb_m2s_gpio_dat),
//     .wb_gpio_sel_o      (wb_m2s_gpio_sel),
//     .wb_gpio_we_o       (wb_m2s_gpio_we),
//     .wb_gpio_cyc_o      (wb_m2s_gpio_cyc),
//     .wb_gpio_stb_o      (wb_m2s_gpio_stb),
//     .wb_gpio_cti_o      (wb_m2s_gpio_cti),
//     .wb_gpio_bte_o      (wb_m2s_gpio_bte),
//     .wb_gpio_dat_i      (wb_s2m_gpio_dat),
//     .wb_gpio_ack_i      (wb_s2m_gpio_ack),
//     .wb_gpio_err_i      (wb_s2m_gpio_err),
//     .wb_gpio_rty_i      (wb_s2m_gpio_rty));
