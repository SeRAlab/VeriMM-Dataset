module top_module(
    input [1:0]x,
    input en,
    output [3:0]y
);assign y = (~en) ? 4'b0000 :
            (x == 2'b00) ? 4'b0001 :
            (x == 2'b01) ? 4'b0010 :
            (x == 2'b10) ? 4'b0100 : 4'b1000;
endmodule