module restoring_divider (  
    input clk,  
    input reset,  
    input start,  
    input [15:0] dividend,  
    input [15:0] divisor,  
    output reg [15:0] quotient,  
    output reg [15:0] remainder,  
    output reg busy  
);  
    reg [15:0] temp_dividend;  
    reg [15:0] temp_divisor;  
    reg [4:0] count;  
    reg [15:0] temp_quotient;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 0;  
            remainder <= 0;  
            busy <= 0;  
            count <= 0;  
            temp_dividend <= 0;  
            temp_divisor <= 0;  
            temp_quotient <= 0;  
        end else if (start) begin  
            busy <= 1;  
            temp_dividend <= dividend;  
            temp_divisor <= divisor;  
            temp_quotient <= 0;  
            count <= 16;  
        end else if (busy) begin  
            temp_quotient <= {temp_quotient[14:0], 1'b1};  
            temp_dividend <= temp_dividend - temp_divisor;  
            if (temp_dividend[15] == 1'b1) begin  
                temp_quotient[0] <= 0;  
                temp_dividend <= temp_dividend + temp_divisor;  
            end  
            count <= count - 1;  
            if (count == 0) begin  
                quotient <= temp_quotient;  
                remainder <= temp_dividend;  
                busy <= 0;  
            end  
        end  
    end  
endmodule