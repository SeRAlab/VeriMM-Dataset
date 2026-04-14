module restoring_divider(clk, rst, start, dividend, quotient, remainder, done);  
    input clk, rst, start;  
    input [4:0] dividend;  
    output reg [4:0] quotient;  
    output reg [4:0] remainder;  
    output reg done;  

    reg [4:0] divisor = 5'd3;  
    reg [4:0] temp_dividend;  
    reg [2:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 5'd0;  
            remainder <= 5'd0;  
            done <= 1'b0;  
            count <= 3'd0;  
        end else if (start) begin  
            temp_dividend <= dividend;  
            quotient <= 5'd0;  
            remainder <= 5'd0;  
            count <= 3'd5;  
            done <= 1'b0;  
        end else if (count > 0) begin  
            temp_dividend <= {temp_dividend[3:0], 1'b0}; // Shift left  
            if (temp_dividend >= divisor) begin  
                temp_dividend <= temp_dividend - divisor;  
                quotient <= {quotient[3:0], 1'b1};  
            end else begin  
                quotient <= {quotient[3:0], 1'b0};  
            end  
            count <= count - 1;  
        end else begin  
            remainder <= temp_dividend;  
            done <= 1'b1;  
        end  
    end  
endmodule