module restoring_divider(clk, reset, start, dividend, divisor, quotient, remainder, done);  
    input clk;  
    input reset;  
    input start;  
    input signed [15:0] dividend;  
    input signed [15:0] divisor;  
    output reg signed [15:0] quotient;  
    output reg signed [15:0] remainder;  
    output reg done;  

    reg [15:0] temp_dividend;  
    reg [15:0] temp_quotient;  
    reg [4:0] count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 0;  
            remainder <= 0;  
            done <= 0;  
            count <= 0;  
        end else if (start) begin  
            temp_dividend <= dividend;  
            temp_quotient <= 0;  
            count <= 16;  
            done <= 0;  
        end else if (count > 0) begin  
            temp_quotient <= {temp_quotient[14:0], 1'b0};  
            temp_dividend = temp_dividend - divisor;  
            if (temp_dividend[15] == 1) begin  
                temp_dividend = temp_dividend + divisor;  
            end else begin  
                temp_quotient[0] = 1;  
            end  
            count <= count - 1;  
        end else begin  
            quotient <= temp_quotient;  
            remainder <= temp_dividend;  
            done <= 1;  
        end  
    end  
endmodule