module non_restoring_divider(clk, rst, dividend, divisor, start, quotient, remainder, done);  
    input clk, rst, start;  
    input [3:0] dividend, divisor;  
    output reg [3:0] quotient;  
    output reg [3:0] remainder;  
    output reg done;  

    reg [3:0] temp_dividend;  
    reg [3:0] temp_remainder;  
    reg [2:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 4'b0;  
            remainder <= 4'b0;  
            temp_dividend <= 4'b0;  
            temp_remainder <= 4'b0;  
            count <= 3'b0;  
            done <= 1'b0;  
        end else if (start) begin  
            temp_dividend <= dividend;  
            temp_remainder <= 4'b0;  
            quotient <= 4'b0;  
            count <= 3'b0;  
            done <= 1'b0;  
        end else if (count < 4) begin  
            temp_remainder = {temp_remainder[2:0], temp_dividend[3]};  
            temp_dividend = {temp_dividend[2:0], 1'b0};  
            if (temp_remainder >= divisor) begin  
                temp_remainder = temp_remainder - divisor;  
                quotient[count] = 1'b1;  
            end  
            count <= count + 1;  
        end else begin  
            remainder <= temp_remainder;  
            done <= 1'b1;  
        end  
    end  
endmodule