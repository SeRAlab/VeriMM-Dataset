module divider_4bit(  
    input clk,  
    input rst,  
    input start,  
    input [3:0] numerator,  
    input [3:0] denominator,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    output reg done  
);  
    reg [3:0] count;  
    reg [4:0] temp_numerator;  
    reg [4:0] temp_denominator;  
    reg [1:0] state;  
    parameter IDLE = 2'b00, DIVIDE = 2'b01, FINISH = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            quotient <= 4'b0000;  
            remainder <= 4'b0000;  
            done <= 0;  
            count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        if (denominator == 0) begin  
                            quotient <= 4'b0000;  
                            remainder <= 4'b0000;  
                            done <= 1;  
                            state <= FINISH;  
                        end else begin  
                            temp_numerator <= {1'b0, numerator};  
                            temp_denominator <= {1'b0, denominator};  
                            quotient <= 0;  
                            count <= 4;  
                            state <= DIVIDE;  
                        end  
                    end  
                end  
                DIVIDE: begin  
                    if (count > 0) begin  
                        if (temp_numerator >= temp_denominator) begin  
                            temp_numerator <= temp_numerator - temp_denominator;  
                            quotient <= {quotient[2:0], 1'b1};  
                        end else begin  
                            quotient <= {quotient[2:0], 1'b0};  
                        end  
                        count <= count - 1;  
                    end else begin  
                        remainder <= temp_numerator[3:0];  
                        done <= 1;  
                        state <= FINISH;  
                    end  
                end  
                FINISH: begin  
                    done <= 1;  
                end  
            endcase  
        end  
    end  
endmodule