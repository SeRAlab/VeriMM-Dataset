module divider_8bit (  
    input clk,  
    input [7:0] numerator,  
    input [7:0] denominator,  
    input start,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] num;  
    reg [7:0] denom;  
    reg [3:0] counter;  
    reg state; // 0: idle, 1: dividing  

    always @(posedge clk) begin  
        if (start) begin  
            if (denominator == 0) begin  
                quotient <= 8'b11111111; // Division by zero output  
                remainder <= 8'b11111111;  
                done <= 1;  
            end else begin  
                num <= numerator;  
                denom <= denominator;  
                quotient <= 0;  
                remainder <= 0;  
                counter <= 8;  
                state <= 1;  
                done <= 0;  
            end  
        end else if (state) begin  
            if (counter > 0) begin  
                if (num >= denom) begin  
                    num <= num - denom;  
                    quotient <= quotient + 1;  
                end  
                counter <= counter - 1;  
            end else begin  
                remainder <= num;  
                state <= 0;  
                done <= 1;  
            end  
        end  
    end  
endmodule