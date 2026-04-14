module divider_4bit (  
    input [3:0] dividend,  
    input [3:0] divisor,  
    input start,  
    input clk,  
    input rst,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    output reg done  
);  
    reg [3:0] temp_dividend;  
    reg [3:0] temp_divisor;  
    reg [3:0] count;  
    reg state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 0;  
            remainder <= 0;  
            done <= 0;  
            count <= 0;  
            state <= 0;  
        end else if (start && !state) begin  
            temp_dividend <= dividend;  
            temp_divisor <= divisor;  
            quotient <= 0;  
            remainder <= dividend;  
            count <= 4;  
            state <= 1;  
        end else if (state) begin  
            if (count > 0) begin  
                if (remainder >= temp_divisor) begin  
                    remainder <= remainder - temp_divisor;  
                    quotient <= quotient + (1 << (4 - count));  
                end  
                count <= count - 1;  
            end else begin  
                done <= 1;  
                state <= 0;  
            end  
        end  
    end  
endmodule