module restoring_divider(
    input clk,
    input rst,
    input [3:0] dividend,
    input [1:0] divisor,
    output reg [3:0] quotient,
    output reg [1:0] remainder,
    output reg done
);
    reg [3:0] A; // Accumulator
    reg [3:0] Q; // Quotient
    reg [1:0] D; // Divisor
    reg [2:0] count; // Counter for number of bits processed
    reg state; // State variable (0 for division, 1 for done)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            D <= 0;
            count <= 0;
            done <= 0;
            state <= 0;
        end else if (state == 0) begin
            if (count < 4) begin
                A <= {A[2:0], dividend[3 - count]};
                Q <= {Q[2:0], 1'b0};
                if (A >= {2'b00, divisor}) begin
                    A <= A - {2'b00, divisor};
                    Q[0] <= 1'b1;
                end
                count <= count + 1;
            end else begin
                quotient <= Q;
                remainder <= A[1:0];
                done <= 1;
                state <= 1;
            end
        end
    end
endmodule