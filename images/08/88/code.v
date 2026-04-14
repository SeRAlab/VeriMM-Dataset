module divider_4bit (  
    input [3:0] dividend,  
    input [3:0] divisor,  
    input start,  
    input clk,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    output reg done  
);  

reg [3:0] count;  
reg [3:0] temp_dividend;  
reg [3:0] temp_divisor;  

always @(posedge clk) begin  
    if (start) begin  
        temp_dividend <= dividend;  
        temp_divisor <= divisor;  
        quotient <= 0;  
        remainder <= 0;  
        count <= 4;  
        done <= 0;  
    end else if (count > 0) begin  
        if (temp_dividend >= temp_divisor) begin  
            temp_dividend <= temp_dividend - temp_divisor;  
            quotient <= quotient + 1;  
        end  
        count <= count - 1;  
    end else begin  
        remainder <= temp_dividend;  
        done <= 1;  
    end  
end  
endmodule