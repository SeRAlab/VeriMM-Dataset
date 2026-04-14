module top_module(branch,jump,reg_rs1,rs_value_sign,opcode);output  branch,jump;
input[5:0] opcode;
input[31:0] reg_rs1,rs_value_sign;
reg branch1;

parameter BRA = 6'b10110;
parameter JUMP = 6'b10101;

always@(*)
begin
if((opcode == BRA) && (rs_value_sign ==  reg_rs1))  branch1 <= 1;
else if (opcode == JUMP) branch1 <=1;
else branch1 = 0;
end
assign branch = branch1;
assign jump = branch1;
endmodule