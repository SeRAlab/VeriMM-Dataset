module srt_divider (  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder  
);  
    integer i;  
    reg [15:0] temp_dividend;  
    reg [15:0] temp_divisor;  
    reg [15:0] temp_quotient;  
  
    always @(*) begin  
        temp_dividend = {8'b0, dividend};  
        temp_divisor = {8'b0, divisor};  
        temp_quotient = 16'b0;  
        quotient = 8'b0;  
        remainder = dividend;  
  
        for (i = 0; i < 8; i = i + 1) begin  
            temp_quotient = {temp_quotient[14:0], remainder[15]};  
            remainder = remainder << 1;  
            remainder[0] = temp_dividend[15];  
            temp_dividend = temp_dividend << 1;  
            if (remainder >= temp_divisor) begin  
                remainder = remainder - temp_divisor;  
                temp_quotient[0] = 1;  
            end  
        end  
  
        quotient = temp_quotient[7:0];  
    end  
endmodule