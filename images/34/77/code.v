module non_restoring_divider (  
    input clk,  
    input reset,  
    input [4:0] dividend,  
    input [4:0] divisor,  
    output reg [4:0] quotient,  
    output reg [4:0] remainder,  
    output reg done  
);  
    reg [4:0] A; // Accumulator  
    reg [4:0] Q; // Quotient  
    reg [4:0] M; // Divisor  
    reg [2:0] count; // Count for 5 cycles  
    reg state; // State to denote process completion  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            A <= 5'b0;  
            Q <= 5'b0;  
            M <= divisor;  
            count <= 3'b0;  
            done <= 0;  
            state <= 0;  
            quotient <= 5'b0;  
            remainder <= 5'b0;  
        end else begin  
            if (count < 5) begin  
                if (state == 0) begin  
                    A <= {A[3:0], dividend[4 - count]};  
                    Q <= {Q[3:0], 1'b0};  
                    if (A >= M) begin  
                        A <= A - M;  
                        Q[0] <= 1;  
                    end  
                end else begin  
                    if (A < M) begin  
                        A <= {A[3:0], 1'b1};  
                        Q <= {Q[3:0], 1'b0};  
                    end  
                end  
                count <= count + 1;  
            end else begin  
                quotient <= Q;  
                remainder <= A;  
                done <= 1;  
            end  
            state <= ~state;  
        end  
    end  
endmodule