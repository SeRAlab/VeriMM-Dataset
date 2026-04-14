module SRT_divider (  
    input clk,  
    input rst,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] temp_dividend;  
    reg [7:0] temp_quotient;  
    reg [3:0] count;  
    reg state; // 0: idle, 1: calculating  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            temp_dividend <= 8'b0;  
            temp_quotient <= 8'b0;  
            count <= 4'b0;  
            done <= 0;  
            state <= 0;  
        end else begin  
            case (state)  
                0: begin // idle state  
                    if (divisor != 0) begin  
                        temp_dividend <= dividend;  
                        temp_quotient <= 8'b0;  
                        count <= 4'b0;  
                        state <= 1;  
                    end  
                end  
                1: begin // calculating state  
                    if (count < 8) begin  
                        if (temp_dividend >= divisor) begin  
                            temp_dividend <= temp_dividend - divisor;  
                            temp_quotient <= (temp_quotient << 1) | 1;  
                        end else begin  
                            temp_quotient <= (temp_quotient << 1);  
                        end  
                        count <= count + 1;  
                    end else begin  
                        quotient <= temp_quotient;  
                        remainder <= temp_dividend;  
                        done <= 1;  
                        state <= 0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule