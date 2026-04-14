module divider_4bit (  
    input wire clk,  
    input wire reset,  
    input wire [3:0] numerator,  
    input wire [3:0] denominator,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder  
);  
    reg [3:0] num;  
    reg [3:0] denom;  
    reg [4:0] temp_quotient;  
    reg [4:0] temp_remainder;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 4'b0000;  
            remainder <= 4'b0000;  
            num <= 4'b0000;  
            denom <= 4'b0000;  
            temp_quotient <= 5'b00000;  
            temp_remainder <= 5'b00000;  
            i <= 0;  
        end else begin  
            if (i == 0) begin  
                num <= numerator;  
                denom <= denominator;  
                temp_quotient <= 5'b00000;  
                temp_remainder <= 5'b00000;  
                i <= 1;  
            end else if (i < 5) begin  
                temp_remainder = {temp_remainder[3:0], num[3-i]};  
                if (temp_remainder >= denom) begin  
                    temp_remainder = temp_remainder - denom;  
                    temp_quotient = temp_quotient | (1 << (4-i));  
                end  
                i <= i + 1;  
            end else begin  
                quotient <= temp_quotient[3:0];  
                remainder <= temp_remainder[3:0];  
                i <= 0;  
            end  
        end  
    end  
endmodule