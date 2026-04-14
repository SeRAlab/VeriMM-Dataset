module restoring_divider(  
    input clk,  
    input reset,  
    input [15:0] dividend,  
    input [15:0] divisor,  
    output reg [15:0] quotient,  
    output reg [15:0] remainder,  
    output reg done  
);  
    reg [15:0] A; // Accumulator  
    reg [15:0] Q; // Quotient  
    reg [15:0] M; // Divisor  
    reg [4:0] count;  
    reg [1:0] state;  
    parameter IDLE = 2'b00, DIVIDE = 2'b01, DONE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            A <= 0;  
            Q <= 0;  
            M <= divisor;  
            count <= 0;  
            state <= IDLE;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (divisor != 0) begin  
                        A <= dividend;  
                        Q <= 0;  
                        count <= 16;  
                        state <= DIVIDE;  
                    end  
                end  
                DIVIDE: begin  
                    A <= {A[14:0], Q[15]}; // Shift left  
                    Q <= {Q[14:0], 1'b1}; // Add 1  
                    A <= A - M; // Subtract divisor  
                    if (A[15] == 1) begin // If A is negative  
                        A <= A + M; // Restore  
                        Q <= {Q[14:0], 1'b0}; // Add 0  
                    end  
                    count <= count - 1;  
                    if (count == 0) begin  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    quotient <= Q;  
                    remainder <= A;  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule