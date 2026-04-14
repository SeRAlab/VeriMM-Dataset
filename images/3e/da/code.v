module qr_decomposition (
    input [15:0] matrix,
    output reg [15:0] Q,
    output reg [15:0] R
);
    // Assuming matrix is organized as:
    // matrix[15:12] = a, matrix[11:8] = b
    // matrix[7:4] = c, matrix[3:0] = d
    // Matrix: | a b |
    //          | c d |

    wire [15:0] a, b, c, d;
    assign a = matrix[15:12];
    assign b = matrix[11:8];
    assign c = matrix[7:4];
    assign d = matrix[3:0];

    always @(*) begin
        // Compute R
        R[15:12] = a; // R[0][0]
        R[11:8] = b; // R[0][1]
        R[7:4] = c; // R[1][0]
        R[3:0] = d; // R[1][1]

        // Compute Q
        Q[15:12] = a / (a * a + c * c) ** 0.5; // Q[0][0]
        Q[11:8] = b / (a * a + c * c) ** 0.5; // Q[0][1]
        Q[7:4] = c / (b * b + d * d) ** 0.5; // Q[1][0]
        Q[3:0] = d / (b * b + d * d) ** 0.5; // Q[1][1]
    end
endmodule