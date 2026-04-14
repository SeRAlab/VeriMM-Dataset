module top_module(input [4:0] EX_MEM_rd, MEM_WB_rd,
                        input [4:0] rs1, rs2,
                        input RegW_in1, RegW_in2,
                        input B_sel,
                        output reg [1:0] fa, fb);always @(EX_MEM_rd, MEM_WB_rd, RegW_in1, RegW_in2, rs1, rs2, B_sel) begin

fa=2'b00;
if (RegW_in1 && EX_MEM_rd) begin
    if (EX_MEM_rd == rs1)
      fa= 2'b10;
end
if (RegW_in2 && MEM_WB_rd) begin
    if (!(RegW_in1 && EX_MEM_rd && (EX_MEM_rd == rs1)) && (MEM_WB_rd==rs1))
      fa= 2'b01;
end

  fb= 2'b00;
if (B_sel)
  fb=2'b11;
else begin
 fb= 2'b00;
   if (RegW_in1 && EX_MEM_rd) begin
    if (EX_MEM_rd == rs2)
      fb= 2'b10;
   end
   if (RegW_in2 && MEM_WB_rd) begin
    if (!(RegW_in1 && EX_MEM_rd && (EX_MEM_rd == rs2)) && (MEM_WB_rd==rs2))
      fb= 2'b01; 
   end
end
end
endmodule