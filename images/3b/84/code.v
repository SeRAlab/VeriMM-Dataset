module divider_8bit (  
    input clk,  
    input rst,  
    input start,  
    input [7:0] dividend,  
    input [3:0] divisor,  
    output reg [7:0] quotient,  
    output reg [3:0] remainder,  
    output reg done  
);  
    reg [7:0] temp_dividend;  
    reg [3:0] temp_divisor;  
    reg [3:0] count;  
    reg [7:0] temp_quotient;  
    reg dividing;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 8'b0;  
            remainder <= 4'b0;  
            done <= 1'b0;  
            dividing <= 1'b0;  
        end else if (start && !dividing) begin  
            if (divisor != 4'b0) begin  
                temp_dividend <= dividend;  
                temp_divisor <= divisor;  
                temp_quotient <= 8'b0;  
                count <= 4'b0;  
                dividing <= 1'b1;  
                done <= 1'b0;  
            end else begin  
                quotient <= 8'b0;  
                remainder <= 4'b0;  
                done <= 1'b1;  
            end  
        end else if (dividing) begin  
            if (count < 8) begin  
                if (temp_dividend >= {4'b0, temp_divisor}) begin  
                    temp_dividend <= temp_dividend - {4'b0, temp_divisor};  
                    temp_quotient <= temp_quotient + 1;  
                end  
                count <= count + 1;  
            end else begin  
                quotient <= temp_quotient;  
                remainder <= temp_dividend[3:0];  
                done <= 1'b1;  
                dividing <= 1'b0;  
            end  
        end  
    end  
endmodule