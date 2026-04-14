module decoder2to4 (
        input [1:0] sel,
        output [3:0] out);

    assign out = 1 << sel;

endmodule