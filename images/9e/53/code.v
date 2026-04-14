module top_module(clk,rst,req_0,req_1,gnt_0,gnt_1);input clk,rst,req_0,req_1;
output reg gnt_0,gnt_1;
parameter S3=2'b11,S2=2'b10,S1=2'b01,S0=2'b00;
reg [1:0] ps;
always @ (posedge clk) begin
	if(rst)
	  ps <= S0;
	else 
	  ps <= {req_0,req_1};
end
always @ (ps,req_1,req_0) begin
case(ps)
	S3: begin 
	  gnt_0 = 1;
	  gnt_1 = 0;
	end
	S2: begin
	  gnt_0 = 0;
	  gnt_1 = 1;
	end
	S1: begin
	  gnt_0 = 1;
	  gnt_1 = 0;
	end
	default: begin
	  gnt_0 = 0;
	  gnt_1 = 0;
	end
endcase
end
endmodule