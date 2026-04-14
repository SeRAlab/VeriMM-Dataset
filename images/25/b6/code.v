module non_restoring_divider(clk, rst, dividend, divisor, quotient, remainder, done);  
    input clk;  
    input rst;  
    input [7:0] dividend;  
    input [7:0] divisor;  
    output reg [7:0] quotient;  
    output reg [7:0] remainder;  
    output reg done;  

    reg [8:0] A; // Augmented dividend  
    reg [7:0] Q; // Quotient  
    reg [7:0] M; // Divisor  
    reg [3:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            A <= 0;  
            Q <= 0;  
            M <= divisor;  
            quotient <= 0;  
            remainder <= 0;  
            done <= 0;  
            count <= 0;  
        end else if (count < 8) begin  
            A <= {A[7:0], dividend[7-count]}; // Shift in the next bit of dividend  
            if (A >= M) begin  
                A <= A - M;  
                Q <= {Q[6:0], 1'b1};  
            end else begin  
                Q <= {Q[6:0], 1'b0};  
            end  
            count <= count + 1;  
        end else begin  
            quotient <= Q;  
            remainder <= A[7:0];  
            done <= 1;  
        end  
    end  
endmodule