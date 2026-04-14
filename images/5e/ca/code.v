module top_module(
  input clk,
  input reset,
  input [3:0] input_a,
  input [3:0] input_b,
  input [1:0] input_c,
  input input_d,
  output reg output_a,
  output reg output_b,
  output reg [1:0] output_c,
  output reg [3:0] output_d
);always @(posedge clk) begin
    if (reset) begin
      output_a <= 1'b0;
      output_b <= 1'b0;
      output_c <= 2'b0;
      output_d <= 4'b0;
    end else begin
      output_a <= (input_a >= 4'b1000);
      output_b <= (input_b <= 4'b0011);
      case (input_c)
        2'b00: output_c <= 2'b00;
        2'b01: output_c <= 2'b01;
        2'b10: output_c <= 2'b10;
        2'b11: output_c <= 2'b11;
      endcase
      output_d <= {input_d, input_c, input_b, input_a};
    end
  end

endmodule