module non_restoring_divider(  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder  
);  
    reg [7:0] temp_dividend;  
    reg [7:0] temp_quotient;  
    integer i;  
  
    always @(*) begin  
        temp_dividend = dividend;  
        temp_quotient = 0;  
        remainder = 0;  
  
        for (i = 7; i >= 0; i = i - 1) begin  
            remainder = {remainder[6:0], temp_dividend[7]};  
            temp_dividend = {temp_dividend[6:0], 1'b0};  
  
            if (remainder >= divisor) begin  
                remainder = remainder - divisor;  
                temp_quotient = {temp_quotient[6:0], 1'b1};  
            end else begin  
                temp_quotient = {temp_quotient[6:0], 1'b0};  
            end  
        end  
        quotient = temp_quotient;  
    end  
endmodule