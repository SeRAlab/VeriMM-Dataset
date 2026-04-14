module SRT_Divider(  
    input clk,  
    input rst,  
    input [15:0] dividend,  
    input [15:0] divisor,  
    output reg [15:0] quotient,  
    output reg [15:0] remainder,  
    output reg done  
);  
    reg [15:0] A, Q, M;  
    reg [4:0] count;  
    reg state;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            A <= 0;  
            Q <= 0;  
            M <= divisor;  
            quotient <= 0;  
            remainder <= 0;  
            count <= 0;  
            done <= 0;  
            state <= 0;  
        end else begin  
            case (state)  
                0: begin  
                    A <= dividend;  
                    Q <= 0;  
                    count <= 15;  
                    state <= 1;  
                end  
                1: begin  
                    if (count > 0) begin  
                        // Perform the division steps  
                        // SRT algorithm steps would go here (simplified)  
                        A = A - M;  
                        if (A[15] == 1) begin  
                            A = A + M;  
                            Q = Q << 1; // Shift left  
                        end else begin  
                            Q = (Q << 1) | 1;  
                        end  
                        count = count - 1;  
                    end else begin  
                        quotient <= Q;  
                        remainder <= A;  
                        done <= 1;  
                        state <= 2;  
                    end  
                end  
                2: begin  
                    // Wait for reset  
                    if (rst) state <= 0;  
                end  
            endcase  
        end  
    end  
endmodule