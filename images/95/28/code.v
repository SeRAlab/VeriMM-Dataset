module top_module(in, out);input [7:0] in;
output [7:0] out;
reg [7:0] out;

always @(in)
begin
case(in)
8'd91:out<=8'd57;
default:out<=0;
endcase
end
endmodule