module top_module(
  input [3:0] in1,
  input [3:0] in2,
  output reg [1:0] out,
  output [3:0] xor_out
);// Comparator logic
  always @* begin
    if (in1 == in2) begin
      out = 2'b00;
    end else if (in1 > in2) begin
      out = 2'b01;
    end else begin
      out = 2'b10;
    end
  end

  // XOR logic
  assign xor_out = in1 ^ in2;

endmodule