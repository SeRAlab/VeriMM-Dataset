module divider_4bit (  
    input clk,  
    input rst,  
    input [3:0] dividend,  
    input [3:0] divisor,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    output reg done  
);  
    reg [3:0] state;  
    reg [3:0] count;  
    reg [3:0] temp_dividend;  
    reg [3:0] temp_quotient;  
    reg [3:0] temp_remainder;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 0;  
            remainder <= 0;  
            state <= 0;  
            done <= 0;  
            count <= 0;  
        end else begin  
            case (state)  
                0: begin  
                    if (divisor != 0) begin  
                        temp_dividend <= dividend;  
                        temp_quotient <= 0;  
                        temp_remainder <= 0;  
                        count <= 4;  
                        state <= 1;  
                    end else begin  
                        done <= 1;  
                    end  
                end  
                1: begin  
                    if (count > 0) begin  
                        temp_remainder <= {temp_remainder[2:0], temp_dividend[3]};  
                        temp_dividend <= {temp_dividend[2:0], 1'b0};  
                        if (temp_remainder >= divisor) begin  
                            temp_remainder <= temp_remainder - divisor;  
                            temp_quotient <= {temp_quotient[2:0], 1'b1};  
                        end else begin  
                            temp_quotient <= {temp_quotient[2:0], 1'b0};  
                        end  
                        count <= count - 1;  
                    end else begin  
                        quotient <= temp_quotient;  
                        remainder <= temp_remainder;  
                        done <= 1;  
                        state <= 0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule