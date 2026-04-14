module non_restoring_divider (
    input clk,
    input rst,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] A; // Accumulator
    reg [3:0] Q; // Quotient
    reg [3:0] M; // Divisor
    reg [3:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 4'b0000;
            Q <= 4'b0000;
            M <= divisor;
            count <= 4'b0000;
            done <= 0;
            quotient <= 4'b0000;
            remainder <= 4'b0000;
        end else if (count < 4) begin
            A <= {A[2:0], Q[3]}; // Shift A left
            Q <= {Q[2:0], 1'b0}; // Shift Q left
            
            if (A >= M) begin
                A = A - M;
                Q[0] = 1'b1; // Set least significant bit of Q
            end else begin
                A = A + M;
                Q[0] = 1'b0; // Clear least significant bit of Q
            end
            
            count <= count + 1;
        end else begin
            quotient <= Q;
            remainder <= A;
            done <= 1;
        end
    end
endmodule