module divider(clk, start, dividend, divisor, quotient, remainder, done);  
    input clk;  
    input start;  
    input [7:0] dividend;  
    input [7:0] divisor;  
    output reg [7:0] quotient;  
    output reg [7:0] remainder;  
    output reg done;  

    reg [7:0] count;  
    reg [15:0] temp_dividend;  
    reg [7:0] temp_divisor;  

    always @(posedge clk) begin  
        if (start) begin  
            temp_dividend <= {8'b0, dividend};  
            temp_divisor <= divisor;  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            count <= 8;  
            done <= 0;  
        end else if (count > 0) begin  
            if (temp_dividend >= {8'b0, temp_divisor}) begin  
                temp_dividend <= temp_dividend - {8'b0, temp_divisor};  
                quotient <= quotient + 1;  
            end  
            count <= count - 1;  
        end else begin  
            remainder <= temp_dividend[7:0];  
            done <= 1;  
        end  
    end  
endmodule