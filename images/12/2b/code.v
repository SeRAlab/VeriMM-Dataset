module non_restoring_divider (
    input [7:0] dividend,
    input [7:0] divisor,
    input start,
    input clk,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg ready
);
    reg [7:0] A, Q;
    reg [3:0] count;
    reg [7:0] M;
    
    always @(posedge clk) begin
        if (start) begin
            A <= 0;
            Q <= dividend;
            M <= divisor;
            count <= 8;
            quotient <= 0;
            remainder <= 0;
            ready <= 0;
        end else if (count > 0) begin
            A <= {A[6:0], Q[7]}; // Shift left A and bring down bit from Q
            Q <= {Q[6:0], 1'b0}; // Shift Q left
            
            if (A >= M) begin
                A <= A - M;
                Q[0] <= 1; // Set least significant bit of Q
            end else begin
                Q[0] <= 0; // Reset least significant bit of Q
            end
            
            count <= count - 1;
        end else if (count == 0) begin
            quotient <= Q;
            remainder <= A;
            ready <= 1;
        end
    end
endmodule