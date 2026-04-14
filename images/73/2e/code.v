module top_module(
  input clk,
  input [7:0] data,
  input RS,
  input RW,
  input E,
  output LCD_RS,
  output LCD_RW,
  output LCD_E,
  output [7:0] LCD_DATA
);parameter width = 16; // width of the LCD screen
parameter height = 2; // height of the LCD screen

reg [7:0] lcd_data_reg;
reg lcd_rs_reg;
reg lcd_rw_reg;
reg lcd_e_reg;

assign LCD_DATA = lcd_data_reg;
assign LCD_RS = lcd_rs_reg;
assign LCD_RW = lcd_rw_reg;
assign LCD_E = lcd_e_reg;

always @(posedge clk) begin
  lcd_data_reg <= data;
  lcd_rs_reg <= RS;
  lcd_rw_reg <= RW;
  lcd_e_reg <= E;
end

endmodule