module restoring_divider(
    input clk,
    input rst,
    input [3:0] A,  // Dividend
    input [3:0] B,  // Divisor
    output reg [3:0] Q,  // Quotient
    output reg [3:0] R   // Remainder
);
    reg [4:0] R_temp;  // Temporary remainder (5 bits)
    reg [3:0] A_temp;  // Temporary dividend
    reg [2:0] count;   // Count for iteration
    reg [1:0] state;   // State variable
    localparam IDLE = 2'b00, DIVIDE = 2'b01, RESTORE = 2'b10, DONE = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 4'b0000;
            R <= 4'b0000;
            R_temp <= 5'b00000;
            A_temp <= A;
            count <= 3'b000;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (A_temp >= B) begin
                        R_temp <= {1'b0, A_temp}; // Start with A
                        Q <= 4'b0001; // First bit of quotient
                        A_temp <= A_temp - B; // Subtract B from A
                        state <= DIVIDE;
                    end else begin
                        Q <= 4'b0000;
                        R <= A_temp; // Remainder is A
                        state <= DONE;
                    end
                end
                DIVIDE: begin
                    if (count < 4) begin
                        R_temp <= {R_temp[3:0], 1'b0}; // Shift left
                        R_temp[0] <= A_temp[3]; // Lower bit of A
                        A_temp <= {A_temp[2:0], 1'b0}; // Shift A
                        if (R_temp >= {1'b0, B}) begin
                            R_temp <= R_temp - {1'b0, B}; // Subtract B
                            Q <= {Q[2:0], 1'b1}; // Append 1 to quotient
                        end else begin
                            Q <= {Q[2:0], 1'b0}; // Append 0 to quotient
                        end
                        count <= count + 1;
                    end else begin
                        R <= R_temp[3:0]; // Set remainder
                        state <= DONE;
                    end
                end
                DONE: begin
                    // Stay in DONE state
                    // Optionally use this state to indicate completion
                end
            endcase
        end
    end
endmodule