module top_module(A, Y);input [6:0] A;
    output Y;
    assign Y = |A;
endmodule