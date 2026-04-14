module top_module(

    input[4:0] rs1_idex,
    input [4:0] rs2_idex,
    input regwrite_memwb,
    input regwrite_exmem,
    input [4:0] rd_memwb,
    input [4:0] rd_exmem,

    output reg [1:0] Forward_A,
    output reg [1:0] Forward_B

);always @(*)
begin

if ((regwrite_exmem==1'b1) && (rd_exmem!=1'b0)&& (rd_exmem==rs1_idex))
    Forward_A=2'b10;
else if ((regwrite_memwb==1'b1)&& (rd_memwb!=1'b0)&& (rd_memwb==rs1_idex))
    Forward_A=2'b01;
else 
	Forward_A=2'b00;

if ((regwrite_exmem==1'b1)&& (rd_exmem!=1'b0)&& (rd_exmem==rs2_idex))
    Forward_B=2'b10;

else if ((regwrite_memwb==1'b1)&& (rd_memwb!=1'b0)&& (rd_memwb==rs2_idex))
    Forward_B=2'b01;
else 
	Forward_B=2'b00;



end
endmodule