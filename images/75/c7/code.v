module top_module(
    clk_i,     
    inst_i,   
    pc_i,
    stall_i, 
    flush_i,  
    inst_o, 
    pc_o,
);input clk_i;
input [31:0] 	inst_i;
input [31:0] 	pc_i;
input stall_i;
input flush_i;

output reg [31:0] 	inst_o;
output reg [31:0] 	pc_o;


always@(posedge clk_i)	begin
	if (~stall_i)begin
		inst_o <= inst_i;
		pc_o <= pc_i;
	end
    if (flush_i)begin
        inst_o <= 32'd0;
    end
end 

endmodule