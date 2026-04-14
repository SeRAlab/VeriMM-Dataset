module divider_8bit(clk, start, dividend, divisor, quotient, remainder, done);  
    input clk;  
    input start;  
    input [7:0] dividend;  
    input [7:0] divisor;  
    output reg [7:0] quotient;  
    output reg [7:0] remainder;  
    output reg done;  

    reg [7:0] count;  
    reg [7:0] temp_dividend;  
    reg [7:0] temp_divisor;  

    always @(posedge clk) begin  
        if (start) begin  
            count <= 0;  
            temp_dividend <= dividend;  
            temp_divisor <= divisor;  
            quotient <= 0;  
            remainder <= 0;  
            done <= 0;  
        end else if (count < 8) begin  
            if (temp_dividend >= temp_divisor) begin  
                temp_dividend <= temp_dividend - temp_divisor;  
                quotient <= quotient + (1 << (7 - count));  
            end  
            count <= count + 1;  
        end else begin  
            remainder <= temp_dividend;  
            done <= 1;  
        end  
    end  
endmodule