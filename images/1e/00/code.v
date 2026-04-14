module lu_decomposition (
    input [3:0] A,
    output reg [3:0] L,
    output reg [3:0] U
);
    always @(*) begin
        // Assuming A is a 2x2 matrix: | A[0] A[1] |
        //                               | A[2] A[3] |
        // U = | A[0] A[1] |
        //     | 0   A[3] - (A[2] * A[1]/A[0]) |

        // L = | 1   0           |
        //     | A[2]/A[0]  1   |

        L = {A[2] / A[0], 1'b0}; // Lower part of L
        U = {A[0], A[1]};       // Upper part of U
        U[2] = A[3] - (A[2] * A[1]) / A[0]; // Calculate U(1,1)
    end
endmodule