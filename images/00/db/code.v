module booth_multiplier (
    input clk,
    input rst,
    input start,
    input signed [7:0] multiplicand,
    input signed [7:0] multiplier,
    output reg signed [15:0] product,
    output reg done
);
    reg [7:0] A, Q;    // Accumulator and multiplier
    reg [8:0] M;       // Multiplicand
    reg [3:0] count;   // Count for bits
    reg Q_1;           // Previous Q bit

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            M <= 0;
            product <= 0;
            done <= 0;
            count <= 0;
            Q_1 <= 0;
        end else if (start) begin
            A <= 0;
            Q <= multiplier;
            M <= {1'b0, multiplicand}; // Extend multiplicand
            count <= 8;                 // We are multiplying 8-bit numbers
            Q_1 <= 0;
            done <= 0;
        end else if (count > 0) begin
            case ({Q[0], Q_1})
                2'b01: A <= A + M;      // A = A + M
                2'b10: A <= A - M;      // A = A - M
            endcase
            {A, Q} <= {A, Q} >> 1;       // Arithmetic shift right
            Q_1 <= Q[0];                 // Store last bit of Q
            count <= count - 1;         // Decrement count
        end else begin
            product <= {A, Q};           // Combine A and Q
            done <= 1;                   // Indicate done
        end
    end
endmodule