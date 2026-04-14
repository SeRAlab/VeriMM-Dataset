module restoring_divider(clk, reset, start, dividend, divisor, quotient, remainder, done);  
    input clk;  
    input reset;  
    input start;  
    input [7:0] dividend;  
    input [7:0] divisor;  
    output reg [7:0] quotient;  
    output reg [7:0] remainder;  
    output reg done;  

    reg [7:0] A; // Accumulator  
    reg [7:0] Q; // Quotient  
    reg [7:0] M; // Divisor  
    reg [3:0] count; // Counter for number of bits  
    reg [1:0] state; // State variable  

    parameter IDLE = 2'b00, DIVIDE = 2'b01, DONE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            A <= 8'b0;  
            Q <= 8'b0;  
            done <= 1'b0;  
            count <= 4'b0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        A <= dividend;  
                        M <= divisor;  
                        Q <= 8'b0;  
                        count <= 4'b1000; // Start with 8 bits  
                        state <= DIVIDE;  
                    end  
                end  
                DIVIDE: begin  
                    // Shift left A and Q  
                    A <= {A[6:0], Q[7]};  
                    Q <= {Q[6:0], 1'b0};  
                    A <= A - M; // Subtract divisor from A  

                    if (A[7] == 1'b1) begin  
                        // Restore A if A < 0  
                        A <= A + M;  
                    end else begin  
                        Q[0] <= 1'b1; // Set the bit in quotient  
                    end  

                    count <= count - 1;  
                    if (count == 4'b0000) begin  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    quotient <= Q;  
                    remainder <= A;  
                    done <= 1'b1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule