module top_module(
	
	clk,
	reset,

	address,
	byteenable,
	read,
	write,
	writedata,

	
	SRAM_DQ,

	
	readdata,
	readdatavalid,

	SRAM_ADDR,
	SRAM_LB_N,
	SRAM_UB_N,
	SRAM_CE_N,
	SRAM_OE_N,
	SRAM_WE_N	
);input						clk;
input						reset;

input			[17: 0]	address;
input			[ 1: 0]	byteenable;
input						read;
input						write;
input			[15: 0]	writedata;


inout			[15: 0]	SRAM_DQ;		


output reg	[15: 0]	readdata;
output reg				readdatavalid;

output reg	[17: 0]	SRAM_ADDR;		
output reg				SRAM_LB_N;		
output reg				SRAM_UB_N;		
output reg				SRAM_CE_N;		
output reg				SRAM_OE_N;		
output reg				SRAM_WE_N;		








reg						is_read;
reg						is_write;
reg			[15: 0]	writedata_reg;









always @(posedge clk)
begin
	readdata			<= SRAM_DQ;
	readdatavalid	<= is_read;
	
	SRAM_ADDR		<= address;
	SRAM_LB_N		<= ~(byteenable[0] & (read | write));
	SRAM_UB_N		<= ~(byteenable[1] & (read | write));
	SRAM_CE_N		<= ~(read | write);
	SRAM_OE_N		<= ~read;
	SRAM_WE_N		<= ~write;
end


always @(posedge clk)
begin
	if (reset)
		is_read		<= 1'b0;
	else
		is_read		<= read;
end

always @(posedge clk)
begin
	if (reset)
		is_write		<= 1'b0;
	else
		is_write		<= write;
end

always @(posedge clk)
begin
	writedata_reg	<= writedata;
end




assign SRAM_DQ	= (is_write) ? writedata_reg : 16'hzzzz;






endmodule