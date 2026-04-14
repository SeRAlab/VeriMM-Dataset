module top_module(clk, EchoPulse, Trigger, D, count, T);input clk, EchoPulse;
output [15:0]D;
output Trigger;
reg Trigger;
reg [15:0]D = 16'h0000;
reg [15:0]temp = 16'h0000;
output reg [3:0]count = 10;
output reg [9:0]T = 1000;


always @(posedge clk) begin
	if ((count > 0) && (T  > 0)) begin
		count = count -1;
		T = T-1;
		Trigger = 1;
	end
	else if ((count == 0) && (T > 0)) begin
		Trigger =0;
		T = T-1;
		if (EchoPulse == 1) begin
			temp = temp + 1;
		end
		else if (EchoPulse == 0) begin
			D = temp;
		end
	end
	else if ((T==0) && (count ==0)) begin 
		T = 1000; 
		count = 10;
		Trigger = 1;
		temp = 16'h0000;
	end
end
endmodule