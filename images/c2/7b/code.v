module adder_8bit(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] Sum,
    output Cout
);

    wire [8:0] tempSum;
    wire [7:0] tempA;
    wire [7:0] tempB;
    
    assign tempA = {Cin, A};
    assign tempB = {Cin, B};
    
    assign tempSum = tempA + tempB;
    
    assign Sum = tempSum[7:0];
    assign Cout = tempSum[8];
    
endmodule