module top_module(
    input A, B, C, D,
    output reg X
);wire A_B, C_D, A_B_C_D;

    // AND gate for inputs A and B
    and gate1(A_B, A, B);

    // AND gate for inputs C and D
    and gate2(C_D, C, D);

    // AND gate for inputs A, B, C, and D
    and gate3(A_B_C_D, A_B, C_D);

    // Output X is high only when all inputs are high
    always @(*) begin
        if (A_B_C_D == 1'b1) begin
            X = 1'b1;
        end
        else begin
            X = 1'b0;
        end
    end

endmodule