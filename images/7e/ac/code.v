module top_module(clk, rst, input_data, input_valid, output_data, output_valid);input clk, rst, input_valid;
  input [7:0] input_data;
  output [7:0] output_data;
  output output_valid;
  
  reg [7:0] data_reg;
  reg valid_reg;
  
  always @(posedge clk) begin
    if (rst) begin
      data_reg <= 0;
      valid_reg <= 0;
    end else if (input_valid) begin
      data_reg <= input_data;
      valid_reg <= 1;
    end else begin
      valid_reg <= 0;
    end
  end
  
  assign output_data = data_reg;
  assign output_valid = valid_reg;
  
endmodule