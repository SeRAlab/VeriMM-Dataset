module divider_8bit (  
    input clk,  
    input rst,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    input start,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] count;  
    reg [15:0] temp_dividend;  
    reg [7:0] temp_quotient;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            done <= 1'b0;  
            count <= 8'b0;  
            temp_dividend <= 16'b0;  
            temp_quotient <= 8'b0;  
        end else if (start) begin  
            temp_dividend <= {8'b0, dividend};  
            temp_quotient <= 8'b0;  
            count <= 8;  
            done <= 1'b0;  
        end else if (count > 0) begin  
            temp_quotient <= {temp_quotient[6:0], 1'b0};  
            temp_dividend <= {temp_dividend[14:0], 1'b0};  
            if (temp_dividend >= {8'b0, divisor}) begin  
                temp_dividend <= temp_dividend - {8'b0, divisor};  
                temp_quotient[0] <= 1'b1;  
            end  
            count <= count - 1;  
        end else if (count == 0) begin  
            quotient <= temp_quotient;  
            remainder <= temp_dividend[7:0];  
            done <= 1'b1;  
        end  
    end  
endmodule