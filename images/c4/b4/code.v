module counter(clk, reset, enable, count);

	input clk, reset, enable;
	output reg [3:0] count;

	always@(posedge clk) begin
		if(reset == 1'b1) begin
			count <= 4'b0000;
		end
		else if(enable == 1'b1) begin
			count <= count + 1;
		end
	end

endmodule

module counter_tb();

	reg clk, reset, enable;
	wire [3:0] count;

	counter dut(.clk(clk), .reset(reset), .enable(enable), .count(count));

	initial begin
		clk = 0;
		reset = 0;
		enable = 0;
		#10 reset = 1;
		#10 reset = 0;
		#10 enable = 1;
	end

	always #5 clk = ~clk;

endmodule