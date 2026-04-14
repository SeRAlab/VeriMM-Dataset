module top_module(
input wire clk,
input wire rst,
input wire speed_up,
output reg [3:0] led
);parameter time_reset=28'd60;
reg [27:0]timer;
reg [27:0]count;


always @ (posedge clk or negedge rst) begin
	if (rst==1'b0) begin
		timer[27:0] <= time_reset[27:0];
	end else if (speed_up==1'b0) begin
		timer[27:0] <= {1'b0,timer[27:1]};
	end
end

always @ (posedge clk or negedge rst) begin
	if (rst==1'b0) begin
		count[27:0] <= 28'b0;
	end else if(speed_up==1'b0) begin
		count[27:0] <= 28'b0;
	end else if (count==4*timer) begin
		count[27:0] <= 28'b0;
	end else begin
		count[27:0] <= count[27:0] + 1'b1;
	end
	
end

always @ (posedge clk or negedge rst) begin
	if (rst==1'b0) begin
		led[3:0] <= 4'b0000;
	end else if (count[27:0]==timer[27:0]) begin
		led[3:0] <= 4'b0001;
	end else if (count[27:0]==2*timer[27:0]) begin
		led[3:0] <= 4'b0010;
	end else if (count[27:0]==3*timer[27:0]) begin
		led[3:0] <= 4'b0100;
	end else if (count[27:0]==4*timer[27:0]) begin
		led[3:0] <= 4'b1000;
	end
end

endmodule