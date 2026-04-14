module top_module(c, display);input [3:0] c;
    output [6:0] display;

    assign display[0] = ~c[3]&~c[2]&~c[1]&c[0] | c[2]&~c[1]&~c[0];
    assign display[1] = c[2]&~c[1]&c[0] | c[2]&c[1]&~c[0];
    assign display[2] = ~c[2]&c[1]&~c[0];
    assign display[3] = ~c[3]&~c[2]&~c[1]&c[0] | c[2]&~c[1]&~c[0] | c[2]&c[1]&c[0];
    assign display[4] = c[0] | c[2]&~c[1];
    assign display[5] = ~c[3]&~c[2]&c[0] | ~c[2]&c[1] | c[1]&c[0];
    assign display[6] = ~c[3]&~c[2]&~c[1] | c[2]&c[1]&c[0];endmodule