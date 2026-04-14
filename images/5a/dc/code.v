module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input Control,
    output [3:0] Sum,
    output Cout
);wire [3:0] XorSum;
    wire [3:0] AndCarry;
    
    assign XorSum = (Control) ? (A ^ B) : (A + B);
    assign AndCarry = (Control) ? ((A & B) << 1) : ((A + B) > 15);
    
    assign Sum = XorSum + (Cin ? 1 : 0);
    assign Cout = AndCarry | ((XorSum + (Cin ? 1 : 0)) > 15);
    
endmodule