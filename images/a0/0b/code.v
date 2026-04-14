module top_module(sys_clk, sys_rst);input sys_clk;
input sys_rst;

parameter WIDTH1 = 0;
parameter WIDTH2 = 0;

localparam big_width = (WIDTH1 >= WIDTH2) ? WIDTH1 : WIDTH2;

wire [31:0] wide = big_width;
wire [31:0] width1 = WIDTH1;
wire [31:0] width2 = WIDTH2;

initial begin
	$strobe("%m wide: %h, width1:%h, width2:%h", wide, width1, width2);
end

endmodule