module restoring_divider(clk, rst, start, numerator, denominator, quotient, remainder, done);  
    input clk, rst, start;  
    input [3:0] numerator, denominator;  
    output reg [3:0] quotient, remainder;  
    output reg done;  

    reg [3:0] temp_numerator, temp_denominator;  
    reg [3:0] count;  
    reg [4:0] dividend;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 4'b0;  
            remainder <= 4'b0;  
            done <= 0;  
            count <= 4'b0;  
        end else if (start) begin  
            temp_numerator <= numerator;  
            temp_denominator <= denominator;  
            quotient <= 4'b0;  
            remainder <= 4'b0;  
            count <= 4'b0;  
            done <= 0;  
        end else if (count < 4) begin  
            dividend <= {remainder, 1'b0};  
            remainder <= dividend - temp_denominator;  
            if (remainder[4] == 1'b0) begin  
                remainder <= remainder[3:0];  
                quotient <= {quotient[2:0], 1'b1};  
            end else begin  
                remainder <= dividend;  
                quotient <= {quotient[2:0], 1'b0};  
            end  
            count <= count + 1;  
        end else begin  
            done <= 1;  
        end  
    end  
endmodule