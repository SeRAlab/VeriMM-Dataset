module top_module(clk, reset, din, sp, dout);input clk, reset;
input [15:0] din;
input [2:0] sp; 
output reg [15:0] dout;

reg [15:0] stack_mem[15:0];
integer i;

always @ (clk) begin
	if(reset) begin
	    dout = 16'h0000;
	    for (i = 0; i < 16; i = i +1) begin
  	  	stack_mem[i] = 16'h0000;
     	    end
	    

	end
	else begin
		if(clk) begin
			stack_mem[sp] = din; 
		end
	
		else if(~clk) begin
			dout = stack_mem[sp]; 
		end
	end
end
endmodule