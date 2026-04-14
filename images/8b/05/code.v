module top_module(in, out);input [3:0] in;
    output [6:0] out;


reg [6:0] out;
always@(in)
begin
case (in)
    0: out = ~7'b0111111;
    1: out = ~7'b0000110;
    2: out = ~7'b1011011;
    3: out = ~7'b1001111;
    4: out = ~7'b1100110;
    5: out = ~7'b1101101;
    6: out = ~7'b1111101;
    7: out = ~7'b0000111;
    8: out = ~7'b1111111;
    9: out = ~7'b1100111;
    10: out = 7'b0001000;
    11: out = 7'b0000011;
    12: out = 7'b1000110;
    13: out = 7'b0100001;
    14: out = 7'b0000110;
    15: out = 7'b0001110;
    default : out = 7'b1111111;
    endcase
    end
endmodule