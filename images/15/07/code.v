module divider_8bit (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] dividend,  
    input wire [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  

    reg [7:0] temp_dividend;  
    reg [7:0] temp_quotient;  
    reg [3:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            temp_dividend <= 8'b0;  
            temp_quotient <= 8'b0;  
            count <= 4'b0;  
            done <= 0;  
        end else if (count < 8) begin  
            temp_dividend <= {remainder[6:0], dividend[7-count]};  
            remainder <= temp_dividend;  
            if (remainder >= divisor) begin  
                remainder <= remainder - divisor;  
                temp_quotient[count] <= 1'b1;  
            end else begin  
                temp_quotient[count] <= 1'b0;  
            end  
            count <= count + 1;  
        end else begin  
            quotient <= temp_quotient;  
            done <= 1;  
        end  
    end  
endmodule