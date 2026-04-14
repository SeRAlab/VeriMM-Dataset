module restoring_divider(clk, rst, start, dividend, divisor, quotient, remainder, done);  
    input clk, rst, start;  
    input [7:0] dividend;  
    input [3:0] divisor;  
    output reg [7:0] quotient;  
    output reg [7:0] remainder;  
    output reg done;  

    reg [8:0] temp_dividend;  
    reg [4:0] count;  
    reg [7:0] temp_quotient;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 0;  
            remainder <= 0;  
            done <= 0;  
            count <= 0;  
            temp_quotient <= 0;  
        end else if (start) begin  
            temp_dividend <= {1'b0, dividend};  
            temp_quotient <= 0;  
            count <= 0;  
            done <= 0;  
        end else if (count < 8) begin  
            temp_dividend <= {temp_dividend[7:0], 1'b0};  
            temp_quotient <= {temp_quotient[6:0], 1'b0};  
            if (temp_dividend >= {1'b0, divisor}) begin  
                temp_dividend <= temp_dividend - {1'b0, divisor};  
                temp_quotient[0] <= 1;  
            end  
            count <= count + 1;  
        end else begin  
            quotient <= temp_quotient;  
            remainder <= temp_dividend[7:0];  
            done <= 1;  
        end  
    end  
endmodule