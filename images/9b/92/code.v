module top_module(
  clk_sys_o,
  clk_adc_o,
  clk_adc2x_o,
  clk_100mhz_o,
  clk_200mhz_o,
  rstn_o
);// Defaults parameters
  parameter CLK_SYS_PERIOD = 20;
  parameter CLK_ADC_PERIOD = 40;
  parameter CLK_ADC_2X_PERIOD = 80;
  
  localparam CLK_100MHZ_PERIOD = 10;
  localparam CLK_200MHZ_PERIOD = 5;

  // Output Clocks
  output reg
    clk_sys_o,
    clk_adc_o,
    clk_adc2x_o,
    clk_100mhz_o,
    clk_200mhz_o;
    
  // Output Reset
  output reg rstn_o;	

  // Reset generate
  initial 
  begin
    clk_sys_o = 0;
    clk_adc_o = 0;
    clk_adc2x_o = 0;
    clk_100mhz_o = 0;
    clk_200mhz_o = 0;
    rstn_o = 0;
    #10
    rstn_o = 1;
  end

  // Clock Generation
  always #(CLK_SYS_PERIOD/2) clk_sys_o <= ~clk_sys_o;
  always #(CLK_ADC_PERIOD/2) clk_adc_o <= ~clk_adc_o;
  always #(CLK_ADC_2X_PERIOD/2) clk_adc2x_o <= ~clk_adc2x_o;
  always #(CLK_100MHZ_PERIOD/2) clk_100mhz_o <= ~clk_100mhz_o;
  always #(CLK_200MHZ_PERIOD/2) clk_200mhz_o <= ~clk_200mhz_o;

endmodule