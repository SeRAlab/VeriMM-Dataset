module top_module(clk,
        wb_rst_i, 
	wb_we_i, wb_stb_i, wb_cyc_i, wb_ack_o,
	we_o, re_o 
	
        );input				clk;


input				wb_rst_i;
input				wb_we_i;
input				wb_stb_i;
input				wb_cyc_i;
output				wb_ack_o;
output				we_o;
output				re_o;

wire				we_o;
reg				wb_ack_o;

always @(posedge clk or posedge wb_rst_i)
begin
	if (wb_rst_i)
	begin
		wb_ack_o <= #1 1'b0;
	end
	else
	begin

		wb_ack_o <= #1 wb_stb_i & wb_cyc_i & ~wb_ack_o; 
	end
end

assign we_o =  wb_we_i & wb_cyc_i & wb_stb_i; 
assign re_o = ~wb_we_i & wb_cyc_i & wb_stb_i; 

endmodule