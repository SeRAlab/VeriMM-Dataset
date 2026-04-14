module top_module(a,b,sel,y);input [31:0] a,b;
input [1:0] sel;

output reg [31:0] y;

always@(a,b,sel)
begin
    if(sel == 2'b00)
        y = a;
    else if(sel == 2'b01)
        y = b;
    else if(sel == 2'b10)
        y = a;
 
end


endmodule