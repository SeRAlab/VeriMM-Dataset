module restoring_divider (
    input wire clk,
    input wire rst,
    input wire [3:0] dividend,
    input wire [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] A; // Register for the dividend
    reg [3:0] Q; // Register for the quotient
    reg [3:0] M; // Register for the divisor
    reg [2:0] count; // Counter for the number of bits processed
    reg state; // State flag (0: processing, 1: done)
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 4'b0000;
            Q <= 4'b0000;
            M <= 4'b0000;
            count <= 3'b000;
            done <= 0;
            state <= 0;
        end else begin
            if (state == 0) begin // Processing state
                if (count < 4) begin
                    A <= {A[2:0], dividend[3 - count]}; // Shift A with dividend bit
                    Q <= {Q[2:0], 1'b0}; // Shift Q left
                    if (A >= M) begin
                        A <= A - M; // Subtract M from A
                        Q[0] <= 1'b1; // Set LSB of Q to 1
                    end
                    count <= count + 1;
                end else begin
                    remainder <= A; // Set remainder
                    quotient <= Q; // Set quotient
                    done <= 1; // Signal done
                    state <= 1; // Move to done state
                end
            end
        end
    end

    always @(posedge clk) begin
        if (state == 0) begin
            M <= divisor; // Load divisor
        end
    end
endmodule