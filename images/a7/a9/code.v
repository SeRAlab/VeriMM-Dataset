module top_module(
    input [31:0] PC_out,
    input [31:0] ALUOut,
    input IorD,
    output reg [31:0] out
);always @(PC_out, ALUOut, IorD)begin
  if(IorD)begin
    out <= ALUOut;
  end
  else
    out <= PC_out;
  end
endmodule