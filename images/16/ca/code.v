module divider_8bit (  
    input [7:0] dividend,  
    input [7:0] divisor,  
    input clk,  
    input reset,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] count;  
    reg [15:0] temp_dividend;  
    reg [8:0] temp_quotient;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 0;  
            remainder <= 0;  
            temp_dividend <= 0;  
            temp_quotient <= 0;  
            count <= 0;  
            done <= 0;  
        end else if (count < 8) begin  
            temp_dividend <= {remainder, dividend[count]};  
            if (temp_dividend >= divisor) begin  
                temp_dividend <= temp_dividend - divisor;  
                temp_quotient[count] <= 1;  
            end else begin  
                temp_quotient[count] <= 0;  
            end  
            remainder <= temp_dividend;  
            count <= count + 1;  
        end else begin  
            quotient <= temp_quotient[7:0];  
            remainder <= temp_dividend[7:0];  
            done <= 1;  
        end  
    end  
endmodule