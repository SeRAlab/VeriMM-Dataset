module top_module(
	
	clk,
	reset,
	
	enable_clk,

	

	
	new_clk,

	rising_edge,
	falling_edge,

	middle_of_high_level,
	middle_of_low_level
);parameter COUNTER_BITS	= 10;
parameter COUNTER_INC	= 10'h001;




input				clk;
input				reset;

input				enable_clk;
	



output	reg			new_clk;

output	reg			rising_edge;
output	reg			falling_edge;

output	reg			middle_of_high_level;
output	reg			middle_of_low_level;








reg			[COUNTER_BITS:1]	clk_counter;








always @(posedge clk)
begin
	if (reset == 1'b1)
		clk_counter	<= {COUNTER_BITS{1'b0}};
	else if (enable_clk == 1'b1)
		clk_counter	<= clk_counter + COUNTER_INC;
end

always @(posedge clk)
begin
	if (reset == 1'b1)
		new_clk	<= 1'b0;
	else
		new_clk	<= clk_counter[COUNTER_BITS];
end

always @(posedge clk)
begin
	if (reset == 1'b1)
		rising_edge	<= 1'b0;
	else
		rising_edge	<= (clk_counter[COUNTER_BITS] ^ new_clk) & ~new_clk;
end

always @(posedge clk)
begin
	if (reset == 1'b1)
		falling_edge <= 1'b0;
	else
		falling_edge <= (clk_counter[COUNTER_BITS] ^ new_clk) & new_clk;
end

always @(posedge clk)
begin
	if (reset == 1'b1)
		middle_of_high_level <= 1'b0;
	else
		middle_of_high_level <= 
			clk_counter[COUNTER_BITS] & 
			~clk_counter[(COUNTER_BITS - 1)] &
			(&(clk_counter[(COUNTER_BITS - 2):1]));
end

always @(posedge clk)
begin
	if (reset == 1'b1)
		middle_of_low_level <= 1'b0;
	else
		middle_of_low_level <= 
			~clk_counter[COUNTER_BITS] & 
			~clk_counter[(COUNTER_BITS - 1)] &
			(&(clk_counter[(COUNTER_BITS - 2):1]));
end











endmodule