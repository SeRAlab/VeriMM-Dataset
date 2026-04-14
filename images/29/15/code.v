module qr_decomposition(
    input [1:0] input_a,
    input [1:0] input_b,
    output [1:0] q1,
    output [1:0] q2
);
    wire [1:0] norm_q1;
    wire [1:0] norm_q2;

    // Compute norm of input_a
    assign norm_q1 = input_a * input_a;
    
    // Normalize q1
    assign q1 = input_a / (norm_q1[1] + norm_q1[0]);
    
    // q2 = input_b - projection of input_b onto q1
    assign norm_q2 = (input_b - (q1 * (input_b * q1))) / (norm_q1[1] + norm_q1[0]); // Simplified form

    // Normalize q2
    assign q2 = norm_q2 / (norm_q2[1] + norm_q2[0]);

endmodule