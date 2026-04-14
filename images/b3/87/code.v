module top_module(
    input [3:0] a,
    input [3:0] b,
    output eq,
    output [1:0] gt,
    output [1:0] lt,
    output [1:0] ge,
    output [1:0] le,
    output [1:0] ne
);assign eq = (a == b);
    assign gt = (a > b) ? 2'b01 : 2'b00;
    assign lt = (a < b) ? 2'b01 : 2'b00;
    assign ge = (a >= b) ? 2'b01 : 2'b00;
    assign le = (a <= b) ? 2'b01 : 2'b00;
    assign ne = (a != b) ? 2'b01 : 2'b00;
endmodule