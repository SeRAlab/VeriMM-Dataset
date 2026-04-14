module top_module(A, B, C);input [1:0] A, B;
    output [1:0] C;
    wire [1:0] B_compl;
    wire [2:0] sum;
    
    // Calculate 2's complement of B
    assign B_compl = ~B + 2'b1;
    
    // Add A and 2's complement of B using a built-in addition
    assign sum = A + B_compl;
    
    // Output the result
    assign C = sum[1:0];
endmodule