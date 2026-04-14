module restoring_divider(input clk, input rst, input [4:0] dividend, input [2:0] divisor, output reg [4:0] quotient, output reg [2:0] remainder);  
    reg [4:0] temp_dividend;  
    reg [2:0] temp_quotient;  
    reg [2:0] count;  
    reg [4:0] subtraction;  
   
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 5'b0;  
            remainder <= 3'b0;  
            temp_dividend <= 5'b0;  
            temp_quotient <= 3'b0;  
            count <= 3'b0;  
        end else begin  
            if (count < 3'd5) begin  
                temp_dividend = {temp_dividend[3:0], dividend[count]};  
                subtraction = temp_dividend - {2'b0, divisor};  
                if (subtraction[4] == 1'b0) begin  
                    temp_dividend = subtraction;  
                    temp_quotient[count] = 1;  
                end  
                count = count + 1;  
            end else begin  
                quotient <= temp_quotient;  
                remainder <= temp_dividend[2:0];  
            end  
        end  
    end  
endmodule