module top_module(
  input clk,
  input reset,
  input [31:0] in_vector,
  output reg [31:0] out_vector
);reg [31:0] temp;
  integer i;

  always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      out_vector <= 0;
    end else begin
      for (i = 0; i < 32; i = i + 1) begin
        temp = in_vector[i];
        out_vector[i] = in_vector[31-i];
        out_vector[31-i] = temp;
      end
    end
  end

endmodule