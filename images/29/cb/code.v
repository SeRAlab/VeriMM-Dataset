module non_restoring_divider (  
    input [4:0] dividend,  
    input [2:0] divisor,  
    output reg [2:0] quotient,  
    output reg [1:0] remainder  
);  
    integer i;  
    reg [4:0] temp_dividend;  
    reg [2:0] temp_quotient;  
    reg [4:0] temp_remainder;  
    
    always @(*) begin  
        temp_dividend = dividend;  
        temp_quotient = 3'b000;  
        temp_remainder = 0;  

        for (i = 0; i < 3; i = i + 1) begin  
            temp_remainder = (temp_remainder << 1) | (temp_dividend[4]);  
            temp_dividend = temp_dividend << 1;  
            temp_quotient = temp_quotient << 1;  

            if (temp_remainder >= divisor) begin  
                temp_remainder = temp_remainder - divisor;  
                temp_quotient = temp_quotient | 1'b1;  
            end  
        end  

        quotient = temp_quotient;  
        remainder = temp_remainder[1:0];  
    end  
endmodule