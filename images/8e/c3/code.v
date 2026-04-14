module top_module(rst, clk, addr, dout, rdy, sram_clk, sram_adv, sram_cre, sram_ce, sram_oe, sram_we, sram_lb, sram_ub, sram_data, sram_addr);input clk, rst;
input [23:0] addr;


output reg [15:0] dout;
output rdy;
output sram_clk, sram_adv, sram_cre, sram_ce, sram_oe, sram_lb, sram_ub;
output [23:1] sram_addr;
output sram_we;
inout [15:0] sram_data;


assign sram_clk = 0;
assign sram_adv = 0;
assign sram_cre = 0;
assign sram_ce  = 0;
assign sram_oe  = 0; 
assign sram_ub  = 0;
assign sram_lb  = 0;

reg [2:0] state = 3'b000;

assign sram_data = 16'hzzzz;
assign sram_addr = {addr[23:1],1'b0};
assign sram_we   = 1; 
assign rdy = (state == 3'b000);

always @(posedge clk) begin
	if (!rst) begin
		if (state == 3'b010) dout <= sram_data;
		
		if (state == 3'b010)
			state <= 3'b000;
		else
			state <= state + 1;
	end else begin
		state <= 3'b000;
	end
end

endmodule