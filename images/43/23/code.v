module top_module(
  input clk,
  input rst,
  input sensor_sel,
  input [15:0] sensor_data,
  output reg sensor_data_valid,
  output reg sensor_data_ready,
  output [15:0] sensor_data_value
);reg [15:0] sensor_data_reg;
  reg sensor_data_valid_reg;
  reg sensor_data_ready_reg;
  
  always @(posedge clk) begin
    if (rst) begin
      sensor_data_reg <= 16'h0000;
      sensor_data_valid_reg <= 1'b0;
      sensor_data_ready_reg <= 1'b0;
    end
    else begin
      if (sensor_sel) begin
        sensor_data_reg <= sensor_data;
        sensor_data_valid_reg <= 1'b1;
        sensor_data_ready_reg <= 1'b1;
      end
      else begin
        sensor_data_reg <= 16'h0000;
        sensor_data_valid_reg <= 1'b0;
        sensor_data_ready_reg <= 1'b0;
      end
    end
  end
  
  assign sensor_data_value = sensor_data_reg;
  assign sensor_data_valid = sensor_data_valid_reg;
  assign sensor_data_ready = sensor_data_ready_reg;

endmodule