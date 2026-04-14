module top_module(A, B, sub, Y);input [3:0] A, B;
    input sub;
    output [3:0] Y;

    wire [3:0] B_2s_comp;
    wire [4:0] sum; // Extra bit for carry

    // Calculate the 2's complement of B if sub is high
    assign B_2s_comp = sub ? (~B + 1'b1) : B;

    // Perform addition of A and the processed B
    assign sum = A + B_2s_comp;

    // Output the lower 4 bits for Y
    assign Y = sum[3:0]; // Ignore carry-out for Y
endmodule