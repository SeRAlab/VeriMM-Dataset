module top_module(clk_i, rst_n, pc_addr_i , pc_instr_i , pc_instr_o, pc_addr_o);input           clk_i;
input	        rst_n;
input  [32-1:0] pc_addr_i;
input  [32-1:0] pc_instr_i;
output [32-1:0] pc_addr_o;
output [32-1:0] pc_instr_o;
 

reg    [32-1:0] pc_addr_o;
reg [32-1:0] pc_instr_o;


always @(posedge clk_i or negedge rst_n) begin
    	if(~rst_n) begin
	    pc_addr_o <= 0;
	    pc_instr_o <=0;
	end
	else begin
	    pc_addr_o <= pc_addr_i;
	    pc_instr_o <= pc_instr_i;
	end
end

endmodule