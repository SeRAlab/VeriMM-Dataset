module top_module(
	input                     clk      ,
	input                     rst      ,
	input      [31:0]         ain      ,
	input      [31:0]         bin      ,
	output reg [31:0]         result   ,
	output reg [31:0]         statistic 
);reg [31:0] result_last;





	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			result      <= 32'h0;
			result_last <= 32'h0;
		end else begin
			result      <= (ain > bin)? ain: bin;
			result_last <= result;
		end
	end
	
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			statistic[31:16] <= 16'hf00d;
			statistic[15:0]  <= 16'h0;
		end else begin
			if ( result != result_last ) begin
				statistic[15:0] <= statistic[15:0] + 16'h1;
			end
		end
	end

endmodule