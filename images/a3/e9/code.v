module top_module(op,clk,reset,stall,stall_pm);input [5:0] op;
input clk,reset;
output reg stall_pm;
output stall;
wire jump,ld,hlt;
reg q,q1,q2;
wire p,p1,p2,stall_pm_tmp;

assign jump = (~op[5])&op[4]&op[3]&op[2]&(~q1);							
assign ld = op[4]&op[2]&(~op[1])&(~op[5])&(~op[3])&(~op[0])&(~q2);
assign hlt = (op==6'b010001)?1'b1:1'b0;											
assign stall= (jump|ld|hlt);													

assign p=(reset==0)?1'b0:jump;													
assign p1=(reset==0)?1'b0:q;														
assign p2=(reset==0)?1'b0:ld;
assign stall_pm_tmp=(reset==0)?1'b0:stall;

always@(posedge clk)
begin
	q<=p;																				
	q1<=p1;
	q2<=p2;
	stall_pm<=stall_pm_tmp;
end
endmodule