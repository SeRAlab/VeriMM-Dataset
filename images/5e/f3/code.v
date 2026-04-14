module top_module(d1, d2, sel, out);input [31:0] d1;
input [31:0] d2;
input sel;
output reg [31:0] out;

always@(d1, d2, sel)
begin
    if (sel ===  1'bx)
        out = d1;
    if (sel == 0)
        out = d1;
    else if (sel == 1)
        out = d2;
end

endmodule