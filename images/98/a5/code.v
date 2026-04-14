module top_module(S,Z,V,N,in1,in2,ALUFun,Sign);output [31:0] S;
output Z,V,N;

input [31:0] in1, in2;
input ALUFun,Sign;
wire [31:0]s_add,s_sub;
wire z_add,v_add,n_add,   z_sub,v_sub,n_sub;
wire [31:0] inv_in2;
assign inv_in2 = ~in2+1;
assign s_add = in1+in2;
assign z_add = (s_add==0); 
assign n_add = Sign&s_add[31];
assign v_add = Sign&(s_add[31]^in1[31])&~(in1[31]^in2[31]);
assign s_sub = in1+inv_in2;
assign z_sub = (s_sub==0);
assign n_sub = Sign&s_sub[31];
assign v_sub = Sign&(s_sub[31]^in1[31])&~(in1[31]^inv_in2[31]);
assign S=ALUFun?s_sub:s_add;
assign Z=ALUFun?z_sub:z_add;
assign N=ALUFun?n_sub:n_add;
assign V=ALUFun?v_sub:v_add;endmodule