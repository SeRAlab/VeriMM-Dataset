module top_module(rst, clk, ie, de, iaddr, daddr, drw, din, iout, dout, pmc_int, pmc_cache_miss_I, pmc_cache_miss_D, pmc_cache_access_I, pmc_cache_access_D, pmc_uart_recv, pmc_uart_send);input rst;
        input clk;
        input ie,de;
        input [31:0] iaddr, daddr;
        input [1:0] drw;
        input [31:0] din;
        output [31:0] iout, dout;

	input pmc_int, pmc_cache_miss_I, pmc_cache_miss_D, pmc_cache_access_I, pmc_cache_access_D, pmc_uart_recv, pmc_uart_send;

	
	reg [31:0] count_int;
	reg [31:0] count_cache_miss_I;
	reg [31:0] count_cache_miss_D;
	reg [31:0] count_cache_access_I;
	reg [31:0] count_cache_access_D;
	reg [31:0] count_uart_recv;
	reg [31:0] count_uart_send;

	assign iout = 0;
	assign dout = 
		daddr == 32'h00000000 ? count_int :
		daddr == 32'h00000004 ? count_cache_miss_I :
		daddr == 32'h00000008 ? count_cache_miss_D :
		daddr == 32'h0000000c ? count_cache_access_I : 
		daddr == 32'h00000010 ? count_cache_access_D :
		daddr == 32'h00000014 ? count_uart_recv : 
		daddr == 32'h00000018 ? count_uart_send : 0;

	
	always @(negedge clk) begin
		if (rst) begin
			count_int <= 0;
			count_cache_miss_I <= 0;
			count_cache_miss_D <= 0;
			count_cache_access_I <= 0;
			count_cache_access_D <= 0;
			count_uart_recv <= 0;
			count_uart_send <= 0;
		end else begin
			count_int <= count_int + pmc_int;
			count_cache_miss_I <= count_cache_miss_I + pmc_cache_miss_I;
			count_cache_miss_D <= count_cache_miss_D + pmc_cache_miss_D;
			count_cache_access_I <= count_cache_access_I + pmc_cache_access_I;
			count_cache_access_D <= count_cache_access_D + pmc_cache_access_D;
			count_uart_recv <= count_uart_recv + pmc_uart_recv;
			count_uart_send <= count_uart_send + pmc_uart_send;
		end
	end
endmodule