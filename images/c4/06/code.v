module adder_subtractor (
    input [3:0] A,
    input [3:0] B,
    input M,
    output [3:0] Y
);

    wire [3:0] B_comp;
    wire [3:0] temp_sum;
    wire [3:0] temp_diff;

    // Complement B if M is 1
    assign B_comp = M ? ~B + 1 : B;

    // Calculate the sum and difference
    assign temp_sum = A + B_comp;
    assign temp_diff = A - B_comp;

    // Select output based on M
    assign Y = M ? temp_diff : temp_sum;

endmodule