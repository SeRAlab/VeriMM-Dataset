module divider_4bit (  
    input clk,  
    input rst,  
    input start,  
    input [3:0] dividend,  
    input [3:0] divisor,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    output reg done  
);  

    reg [3:0] counter;  
    reg [3:0] temp_dividend;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 4'b0000;  
            remainder <= 4'b0000;  
            temp_dividend <= 4'b0000;  
            counter <= 4'b0000;  
            done <= 1'b0;  
        end else if (start) begin  
            if (counter == 4'b0000) begin  
                temp_dividend <= dividend;  
                quotient <= 4'b0000;  
                remainder <= 4'b0000;  
                done <= 1'b0;  
            end else if (counter < 4) begin  
                if (temp_dividend >= divisor) begin  
                    temp_dividend <= temp_dividend - divisor;  
                    quotient <= quotient + 1;  
                end  
            end  
            counter <= counter + 1;  
            if (counter == 4'b0011) begin  
                remainder <= temp_dividend;  
                done <= 1'b1;  
            end  
        end  
    end  
endmodule