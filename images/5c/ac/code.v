module top_module(
	   input a,
	   input b,
	   output reg q);always @ (/*AS*/a, b) begin
     if (b == 1) begin
       q = a;
     end else begin
       q = b;
     end
   end
endmodule