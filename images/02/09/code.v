module restoring_divider (  
    input [4:0] dividend,  
    input [2:0] divisor,  
    input start,  
    input clk,  
    input reset,  
    output reg [4:0] quotient,  
    output reg [1:0] remainder,  
    output reg done  
);  

    reg [4:0] A;  
    reg [2:0] Q;  
    reg [2:0] M;  
    reg [2:0] count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            A <= 5'b0;  
            Q <= 3'b0;  
            M <= divisor;  
            quotient <= 5'b0;  
            remainder <= 2'b0;  
            done <= 0;  
            count <= 3'b0;  
        end else if (start) begin  
            if (count < 3'd5) begin  
                A <= {A[3:0], Q[count]};  
                A <= A - M;  
                if (A[4] == 1) begin  
                    A <= A + M;  
                    Q[count+1] <= 0;  
                end else begin  
                    Q[count+1] <= 1;  
                end  
                count <= count + 1;  
            end else begin  
                quotient <= Q;  
                remainder <= A[1:0];  
                done <= 1;  
            end  
        end  
    end  
endmodule