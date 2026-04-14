module top_module(
  input [3:0] A,
  input [3:0] B,
  input ADD,
  input SUB,
  output reg [3:0] C
);always @(*) begin
  if (ADD) begin
    C <= A + B;
  end else if (SUB) begin
    C <= A - B;
  end else begin
    C <= 4'bxxxx; // Output is undefined if both ADD and SUB are high
  end
end

endmodule