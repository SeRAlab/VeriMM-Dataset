module Divider_8bit (  
    input wire clk,  
    input wire rst,  
    input wire start,  
    input wire [7:0] dividend,  
    input wire [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] count;  
    reg [7:0] temp_dividend;  
    reg [7:0] temp_quotient;  
    reg [7:0] temp_remainder;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 0;  
            remainder <= 0;  
            done <= 0;  
            count <= 0;  
        end else if (start) begin  
            temp_dividend <= dividend;  
            temp_quotient <= 0;  
            temp_remainder <= 0;  
            count <= 8;  
            done <= 0;  
        end else if (count > 0) begin  
            temp_remainder <= (temp_remainder << 1) | (temp_dividend[7]);  
            temp_dividend <= temp_dividend << 1;  
            if (temp_remainder >= divisor) begin  
                temp_remainder <= temp_remainder - divisor;  
                temp_quotient <= (temp_quotient << 1) | 1;  
            end else begin  
                temp_quotient <= (temp_quotient << 1);  
            end  
            count <= count - 1;  
        end else begin  
            quotient <= temp_quotient;  
            remainder <= temp_remainder;  
            done <= 1;  
        end  
    end  
endmodule