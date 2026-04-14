module restoring_divider(  
    input clk,  
    input rst,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] A; // Register to hold the dividend  
    reg [7:0] Q; // Register to hold the quotient  
    reg [7:0] M; // Register to hold the divisor  
    reg [3:0] count; // Count for the number of shifts  
    reg state; // State variable  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            A <= 0;  
            Q <= 0;  
            M <= 0;  
            count <= 0;  
            done <= 0;  
            quotient <= 0;  
            remainder <= 0;  
            state <= 0;  
        end else begin  
            case (state)  
                0: begin  
                    A <= dividend;  
                    M <= divisor;  
                    Q <= 0;  
                    count <= 8;  
                    state <= 1;  
                end  
                1: begin  
                    A <= A - M;  
                    Q <= {Q[6:0], 1'b1};  
                    if (A[7] == 1) begin  
                        A <= A + M;  
                        Q <= {Q[6:0], 1'b0};  
                    end  
                    count <= count - 1;  
                    if (count == 0) begin  
                        remainder <= A;  
                        quotient <= Q;  
                        done <= 1;  
                        state <= 2;  
                    end  
                end  
                2: begin  
                    done <= 0;  
                    state <= 0;  
                end  
            endcase  
        end  
    end  
endmodule