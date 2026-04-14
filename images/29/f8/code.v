module restoring_divider (  
    input clk,  
    input reset,  
    input [3:0] dividend,  
    input [1:0] divisor,  
    output reg [3:0] quotient,  
    output reg [1:0] remainder,  
    output reg done  
);  

    reg [3:0] temp;  
    reg [1:0] counter;  
    reg [3:0] sub;  
    reg [1:0] state;  

    parameter IDLE = 2'b00, DIVIDE = 2'b01, DONE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 4'b0000;  
            remainder <= 2'b00;  
            done <= 1'b0;  
            counter <= 2'b00;  
            temp <= dividend;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (divisor != 2'b00) begin  
                        state <= DIVIDE;  
                        counter <= 2'b00;  
                    end  
                end  
                DIVIDE: begin  
                    if (counter < 4) begin  
                        sub = temp - {2'b00, divisor};  
                        if (sub[3] == 1'b0) begin  
                            temp <= sub;  
                            quotient <= {quotient[2:0], 1'b1};  
                        end else begin  
                            quotient <= {quotient[2:0], 1'b0};  
                        end  
                        counter <= counter + 1;  
                    end else begin  
                        remainder <= temp[1:0];  
                        done <= 1'b1;  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    done <= 1'b0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule