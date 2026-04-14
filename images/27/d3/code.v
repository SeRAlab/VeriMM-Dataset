module TwoBitAdder (
    input [1:0] A,
    input [1:0] B,
    output [2:0] Sum
);
    assign Sum = A + B;
endmodule