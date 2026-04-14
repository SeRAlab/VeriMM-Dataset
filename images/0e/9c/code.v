module restoring_divider (
    input clk,
    input reset,
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder,
    output reg done
);
    reg [15:0] A; // Accumulator
    reg [15:0] Q; // Quotient
    reg [15:0] M; // Divisor
    reg [4:0] count; // Counter for iterations
    reg state; // State variable

    localparam IDLE = 1'b0;
    localparam DIVIDE = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 16'b0;
            Q <= 16'b0;
            M <= divisor;
            count <= 5'b0;
            done <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (count < 16) begin
                        A <= (A << 1) | (dividend[15 - count]); // Shift A and append next bit of dividend
                        Q <= (Q << 1); // Shift Q
                        if (A >= M) begin
                            A <= A - M; // Subtract divisor from A
                            Q <= Q | 1'b1; // Set the least significant bit of Q
                        end
                        count <= count + 1; // Increment count
                    end else begin
                        quotient <= Q; // Assign the quotient
                        remainder <= A; // Assign the remainder
                        done <= 1'b1; // Signal that division is done
                        state <= IDLE; // Transition back to IDLE
                    end
                end
                DIVIDE: begin
                    // This state can be used for further control if needed
                end
            endcase
        end
    end
endmodule