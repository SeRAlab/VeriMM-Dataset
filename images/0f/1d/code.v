module non_restoring_divider (  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder  
);  
    integer i;  
    reg [7:0] temp_dividend;  
    reg [7:0] temp_quotient;  
    reg [7:0] temp_remainder;  
    always @(*) begin  
        temp_dividend = dividend;  
        temp_quotient = 0;  
        temp_remainder = 0;  
        for (i = 7; i >= 0; i = i - 1) begin  
            temp_remainder = {temp_remainder[6:0], temp_dividend[i]};  
            if (temp_remainder >= divisor) begin  
                temp_remainder = temp_remainder - divisor;  
                temp_quotient = {temp_quotient[6:0], 1'b1};  
            end else begin  
                temp_quotient = {temp_quotient[6:0], 1'b0};  
            end  
        end  
        quotient = temp_quotient;  
        remainder = temp_remainder;  
    end  
endmodule