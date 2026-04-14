module top_module(
    input [31:0] A,
    input [31:0] Pc,
    input ALUSrcA,
    output reg [31:0] muxout
);always @(A, Pc, ALUSrcA)begin
  if (ALUSrcA)begin
    muxout <= A;
  end
  else
    muxout <= Pc;
end
endmodule