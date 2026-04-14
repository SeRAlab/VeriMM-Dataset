module LU_decomposition (
    input [1:0] a, // 2-bit input for matrix
    input [1:0] b,
    input [1:0] c,
    input [1:0] d,
    output reg [3:0] L, // 4-bit output for L matrix
    output reg [3:0] U  // 4-bit output for U matrix
);

always @(*) begin
    // Compute L matrix
    L = {2'b01, c / d, 2'b01}; // L = | 1   0 |
                                 //     | c/d 1 |

    // Compute U matrix
    U = {a, b, 4'b0000} + {2'b00, d - (c * b / d)}; // U = | a   b |
                                                     //     | 0   d - (c * b / d) |

end
endmodule