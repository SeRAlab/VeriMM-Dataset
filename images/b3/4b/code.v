module top_module(
  input clk,
  input rst,
  input [7:0] in_temp,
  input [7:0] set_temp,
  output reg [7:0] fan_speed,
  output reg over_temp
);parameter temp_max = 80; // maximum allowed temperature
parameter fan_max = 255; // maximum fan speed

reg [7:0] temp_diff;
reg [7:0] scaled_fan_speed;

always @ (posedge clk or posedge rst) begin
  if (rst) begin
    fan_speed <= 0;
    over_temp <= 0;
  end else begin
    temp_diff <= in_temp - set_temp;
    if (in_temp > temp_max) begin
      over_temp <= 1;
      fan_speed <= fan_max;
    end else if (temp_diff <= 0) begin
      over_temp <= 0;
      fan_speed <= 0;
    end else begin
      over_temp <= 0;
      scaled_fan_speed <= (fan_max * temp_diff) / (temp_max - set_temp);
      fan_speed <= scaled_fan_speed;
    end
  end
end

endmodule