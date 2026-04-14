module divider_8bit (  
    input clk,  
    input rst,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] count;  
    reg [7:0] tmp_dividend;  
    reg [7:0] tmp_divisor;  
    reg [7:0] tmp_quotient;  
    reg [7:0] tmp_remainder;  
    reg start;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            count <= 8'b0;  
            done <= 0;  
            start <= 0;  
        end else if (start) begin  
            if (count < 8) begin  
                tmp_remainder = {tmp_remainder[6:0], tmp_dividend[7]};  
                tmp_dividend = {tmp_dividend[6:0], 1'b0};  
                if (tmp_remainder >= tmp_divisor) begin  
                    tmp_remainder = tmp_remainder - tmp_divisor;  
                    tmp_quotient[count] = 1;  
                end  
                count = count + 1;  
            end else begin  
                quotient <= tmp_quotient;  
                remainder <= tmp_remainder;  
                done <= 1;  
                start <= 0;  
            end  
        end else begin  
            if (divisor != 0) begin  
                tmp_dividend <= dividend;  
                tmp_divisor <= divisor;  
                tmp_quotient <= 8'b0;  
                tmp_remainder <= 8'b0;  
                count <= 0;  
                start <= 1;  
                done <= 0;  
            end else begin  
                quotient <= 8'b11111111;  
                remainder <= 8'b11111111;  
                done <= 1;  
            end  
        end  
    end  
endmodule