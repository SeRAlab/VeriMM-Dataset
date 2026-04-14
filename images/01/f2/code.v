module non_restoring_divider(
    input clk,
    input rst,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [3:0] state;
    reg [8:0] A; // A will hold the intermediate values
    reg [7:0] B; // B holds the divisor
    reg [7:0] Q; // Q holds the quotient
    parameter IDLE = 4'b0000, LOAD = 4'b0001, SHIFT = 4'b0010, SUBTRACT = 4'b0011, ADD = 4'b0100, DONE = 4'b0101;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            quotient <= 0;
            remainder <= 0;
            A <= 0;
            B <= 0;
            Q <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        A <= {1'b0, dividend}; // Load dividend into A
                        B <= divisor;          // Load divisor into B
                        Q <= 8'b0;             // Initialize quotient
                        state <= LOAD;
                    end
                end
                LOAD: begin
                    state <= SHIFT;
                end
                SHIFT: begin
                    A <= {A[7:0], Q[7]}; // Shift left
                    Q <= {Q[6:0], 1'b0}; // Shift quotient
                    state <= SUBTRACT;
                end
                SUBTRACT: begin
                    if (A >= {1'b0, B}) begin
                        A <= A - {1'b0, B}; // A = A - B
                        Q[0] <= 1;          // Set the least significant bit of quotient
                    end else begin
                        Q[0] <= 0;          // Clear the least significant bit of quotient
                    end
                    state <= ADD;
                end
                ADD: begin
                    if (A[8] == 1) begin
                        A <= {1'b0, A[7:1]}; // Restore A
                        Q[0] <= 0;            // Clear the least significant bit of quotient
                    end else begin
                        A <= {1'b0, A[7:1]}; // Keep A
                    end
                    if (Q == 8'b11111111) begin
                        done <= 1;          // Finish division
                        state <= DONE;
                    end else begin
                        state <= SHIFT;     // Go to next iteration
                    end
                end
                DONE: begin
                    quotient <= Q;        // Set quotient output
                    remainder <= A[7:0];  // Set remainder output
                    done <= 1;
                end
            endcase
        end
    end
endmodule