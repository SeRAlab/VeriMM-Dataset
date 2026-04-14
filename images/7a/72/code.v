module subtractor32bit(a, b, difference);
    input [31:0] a;
    input [31:0] b;
    output [31:0] difference;

    assign difference = a - b;
endmodule