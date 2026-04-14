module top_module(input clk_60mhz, output [5:0] led, output [1:0] user_io);reg [26:0] div = 0;

	 always @ ( posedge clk_60mhz ) begin
	 	div <= div + 1'b1;
	 end

     
	 assign led = ~div[26:21];
	 assign user_io = div[25:24];

endmodule