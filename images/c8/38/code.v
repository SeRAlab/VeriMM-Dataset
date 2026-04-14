module adder(input [7:0] A, input [7:0] B, output [7:0] S, output C_out);

    wire [7:0] sum;
    
    assign sum = A + B;
    
    assign S = sum;
    
    assign C_out = sum[8];

endmodule