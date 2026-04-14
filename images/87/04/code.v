module top_module(
  input clk,
  input reset,
  input [31:0] input_data,
  output [31:0] shifted_data,
  output zero_flag
);reg [31:0] shifted_data_reg;
  reg zero_flag_reg;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      shifted_data_reg <= 32'h00000000;
      zero_flag_reg <= 1'b0;
    end else begin
      shifted_data_reg <= {input_data[30:0], 1'b0};
      zero_flag_reg <= (input_data == 32'h00000000) ? 1'b1 : 1'b0;
    end
  end

  assign shifted_data = shifted_data_reg;
  assign zero_flag = zero_flag_reg;

endmodule