module data_forwarding (
    input [4:0] A,
    input [4:0] B,
    input [4:0] X,
    input select,
    output [4:0] Z
);
    wire [4:0] sum;
    
    assign sum = A + B;
    assign Z = select ? X : sum;
endmodule