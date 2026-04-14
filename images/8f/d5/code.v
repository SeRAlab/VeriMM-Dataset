module top_module(
  input [n-1:0] in1,
  input [n-1:0] in2,
  output reg [1:0] comp
);parameter n = 4; // number of bits in the input signals

always @(*) begin
  if (in1 < in2) begin
    comp = 2'b01; // in1 < in2
  end else if (in1 == in2) begin
    comp = 2'b10; // in1 = in2
  end else begin
    comp = 2'b10; // in1 > in2
  end
end

endmodule