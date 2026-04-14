module restoring_divider (  
    input clk,  
    input reset,  
    input start,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] A; // Accumulator  
    reg [7:0] B; // Divisor  
    reg [3:0] count;  
    reg state; // 0: idle, 1: working  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            A <= 8'b0;  
            B <= 8'b0;  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            count <= 4'b0;  
            done <= 0;  
            state <= 0;  
        end else if (start && state == 0) begin  
            A <= dividend;  
            B <= divisor;  
            quotient <= 8'b0;  
            count <= 4'b1000; // 8 bits for division  
            state <= 1;  
        end else if (state == 1 && count > 0) begin  
            A <= A << 1;  
            A[0] <= 1'b0;  
            A[7:0] <= {A[6:0], 1'b0};  
            A <= A - B;  
            if (A[7] == 1'b0) begin  
                quotient <= {quotient[6:0], 1'b1};  
            end else begin  
                A <= A + B;  
                quotient <= {quotient[6:0], 1'b0};  
            end  
            count <= count - 1;  
        end else if (count == 0) begin  
            remainder <= A;  
            done <= 1;  
            state <= 0;  
        end  
    end  
endmodule