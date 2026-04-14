module top_module(in, out);output reg [3:0]out;
input [1:0] in;


always@(in)begin
if (in==2'b00)
 out=4'b1110;
else if (in==2'b01)
out=4'b1101;
else if(in==2'b10) 
out=4'b1011;
else
out=4'b0111;

end

endmodule