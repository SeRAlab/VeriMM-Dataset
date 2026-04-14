module top_module(imm,PCplus,EXTOp,LUOp,ConBA,immout);input [15:0] imm;
input [31:0] PCplus;
input EXTOp;
input LUOp;
output [31:0] ConBA;
output [31:0] immout;

reg [31:0] extimm;

always @(*)
begin
  if(EXTOp)
  begin
    if(imm[15]) extimm <= {16'hffff,imm};
    else extimm <= {16'h0,imm};
  end
  else extimm <= {16'h0,imm};
end

assign ConBA = PCplus + (extimm << 2);
assign immout = (LUOp == 1'b1) ? {imm,16'h0} : extimm;

endmodule