module divider (  
    input clk,  
    input rst,  
    input [7:0] numerator,  
    input [7:0] denominator,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] temp_numerator;  
    reg [7:0] temp_denominator;  
    reg [3:0] count;  
    reg [7:0] result;  
    reg division_in_progress;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            done <= 0;  
            division_in_progress <= 0;  
            count <= 0;  
        end else if (!division_in_progress) begin  
            if (denominator != 0) begin  
                temp_numerator <= numerator;  
                temp_denominator <= denominator;  
                quotient <= 8'b0;  
                remainder <= 8'b0;  
                count <= 8;  
                division_in_progress <= 1;  
                done <= 0;  
            end else begin  
                quotient <= 8'b0;  
                remainder <= numerator;  
                done <= 1;  
            end  
        end else if (count > 0) begin  
            if (temp_numerator >= temp_denominator) begin  
                temp_numerator <= temp_numerator - temp_denominator;  
                quotient <= quotient + 1;  
            end  
            count <= count - 1;  
        end else begin  
            remainder <= temp_numerator;  
            done <= 1;  
            division_in_progress <= 0;  
        end  
    end  
endmodule