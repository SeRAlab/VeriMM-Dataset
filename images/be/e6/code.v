module top_module(a, b, cin, sum, cout);input [3:0] a, b;
input cin;


output [3:0] sum;
output cout;


reg [4:0] temp;
always @(*) 
begin
temp = {1'b0,a} + {1'b0,b} + {1'b0,cin};
end
assign sum = temp[3:0];
assign cout = temp[4];
endmodule