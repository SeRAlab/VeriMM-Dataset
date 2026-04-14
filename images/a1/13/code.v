module top_module(input [31:0] imm,output reg [31:0]  branch_address);always@(*)
begin
  branch_address <= imm << 2;
end
endmodule