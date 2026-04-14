module top_module(input in, enable, output reg [1:0] out);always @(in or enable)
    if(!enable)
	    out = 2'b00;
	else begin
	   case (in)
	       1'b0 : out = 2'b01;
	       1'b1 : out = 2'b10;
	    endcase
	end
endmodule