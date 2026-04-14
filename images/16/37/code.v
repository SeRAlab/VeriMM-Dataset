module cholesky_decomposition (
    input clk,
    input [3:0] matrix_in, // 4-bit input matrix [a11 a12 a21 a22]
    output reg [3:0] l_out // 4-bit output lower triangular matrix [l11 l21 l22]
);
    reg [1:0] state;

    always @(posedge clk) begin
        case(state)
            2'b00: begin
                // Initialize L matrix
                l_out <= 4'b0000;
                state <= 2'b01;
            end
            2'b01: begin
                // Calculate l11 and l21
                l_out[3:2] <= matrix_in[3:2]; // l11 = sqrt(a11)
                l_out[1:0] <= matrix_in[1:0] / l_out[3:2]; // l21 = a21 / l11
                state <= 2'b10;
            end
            2'b10: begin
                // Calculate l22
                l_out[0] <= matrix_in[0] - (l_out[1:0] * l_out[1:0]); // l22 = a22 - l21^2
                state <= 2'b11;
            end
            2'b11: begin
                // Finish computation
                state <= 2'b00; // Reset state
            end
        endcase
    end
endmodule