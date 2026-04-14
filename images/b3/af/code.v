module top_module(
  input clk,
  input reset,
  input [3:0] red_intensity,
  input [3:0] green_intensity,
  input [3:0] blue_intensity,
  output reg [9:0] red_voltage,
  output reg [9:0] green_voltage,
  output reg [9:0] blue_voltage
);reg [9:0] red_voltage_reg;
reg [9:0] green_voltage_reg;
reg [9:0] blue_voltage_reg;

always @ (posedge clk) begin
  if (reset) begin
    red_voltage_reg <= 10'd0;
    green_voltage_reg <= 10'd0;
    blue_voltage_reg <= 10'd0;
  end
  else begin
    red_voltage_reg <= red_intensity * 10'd64;
    green_voltage_reg <= green_intensity * 10'd64;
    blue_voltage_reg <= blue_intensity * 10'd64;
  end
end

assign red_voltage = red_voltage_reg;
assign green_voltage = green_voltage_reg;
assign blue_voltage = blue_voltage_reg;

endmodule