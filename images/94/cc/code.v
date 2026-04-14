module top_module(c, display);input c;
    output [6:0] display;
    wire [6:0] one = 7'b1111001, zero = 7'b1000000;
    assign display = ({7{~c}} & zero) | ({7{c}} & one);endmodule