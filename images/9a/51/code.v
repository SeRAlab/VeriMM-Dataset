module top_module(in, out, sel);input [31:0] in;
    
   input [1:0]sel;
    output reg [31:0] out;
	always @(in) begin
	out<=in;
	if(sel[0]==1) begin
	   if(in[7]==0) begin
	    out[31:8] <= 24'b000000000000000000000000;
	    out [7:0] <= in[7:0];
	    end 
	   else begin
	       out[31:8] <= 24'b111111111111111111111111;
	       out [7:0] <= in[7:0];
	   end
	    
    end
    if(sel[1]==1) begin
       if(in[15]==0) begin
            out[31:16] <= 16'b0000000000000000;
            out [15:0] <= in[15:0];
            end 
           else begin
               out[31:16] <= 16'b1111111111111111;
               out [15:0] <= in[15:0];
           end
           end
	end
endmodule