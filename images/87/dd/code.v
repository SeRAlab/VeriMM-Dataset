module top_module(
  input [n-1:0] in1,
  input [n-1:0] in2,
  output reg [1:0] out
);parameter n = 4; // number of bits in each input value

always @(*) begin
  if (in1 > in2) begin
    out = 2'b01;
  end else if (in1 == in2) begin
    out = 2'b00;
  end else begin
    out = 2'b10;
  end
end

endmodule