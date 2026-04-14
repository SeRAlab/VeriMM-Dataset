module restoring_divider(  
    input clk,  
    input rst,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] temp_dividend;  
    reg [7:0] temp_divisor;  
    reg [3:0] count;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 0;  
            remainder <= 0;  
            count <= 0;  
            done <= 0;  
        end else if (done == 0) begin  
            if (count == 0) begin  
                temp_dividend <= dividend;  
                temp_divisor <= divisor;  
                if (divisor == 0) begin  
                    quotient <= 0;  
                    remainder <= 0;  
                    done <= 1;  
                end else begin  
                    count <= 8;  
                end  
            end else begin  
                temp_dividend <= {temp_dividend[6:0], 1'b0};  
                quotient <= {quotient[6:0], 1'b0};  
                if (temp_dividend >= temp_divisor) begin  
                    temp_dividend <= temp_dividend - temp_divisor;  
                    quotient[0] <= 1;  
                end  
                count <= count - 1;  
                if (count == 1) begin  
                    remainder <= temp_dividend;  
                    done <= 1;  
                end  
            end  
        end  
    end  
endmodule