module top_module(divident, divisor, quotient);input wire [31:0] divident;
input wire [31:0] divisor;
output reg [31:0] quotient;

reg [47:0] tmpDivident;
reg [23:0] tmpDivisor;
reg [25:0] tmpQuotient;
reg [25:0] remainder;
reg [8:0] exponent;
reg [8:0] tmp;

integer i;

always @(divident or divisor)
begin
    quotient = 0;
    remainder = 0;
    tmpDivident = {1'b1, divident[22:0], 24'b0}; // Fixed width issue
    tmpDivisor = {1'b1, divisor[22:0]}; // Fixed width issue
    exponent = divident[30:23] + 128 - divisor[30:23];
    tmpQuotient = 0;
    
    tmp = divident[30:23] + 127;
    if (tmp < divisor[30:23])
    begin
        quotient = 0;
    end
    else if (tmp - divisor[30:23] > 254)
    begin
        quotient = {divident[31]^divisor[31], 8'b1, 23'b0};
    end
    else if (divident == 0 || divisor[30:23] - 255 == 0)
    begin
        quotient = 0;
    end
    else if (divident[30:23] == 255)
    begin
        quotient = divident;
    end
    else if (divisor == 0)
    begin
        quotient = {divident[31], 8'b1, 23'b0};
    end
    else
    begin
        for (i = 48; i > 0; i = i - 1)
        begin
            remainder = {remainder[25:0], tmpDivident[i-1]};
            tmpQuotient = tmpQuotient << 1;
            if (remainder >= tmpDivisor)
            begin
                tmpQuotient = tmpQuotient + 1;
                remainder = remainder - tmpDivisor;
            end
        end
        
        for (i = 3; i > 0; i = i - 1)
        begin
            if (tmpQuotient[25] != 1)
            begin
                tmpQuotient = tmpQuotient << 1;
                exponent = exponent - 1;
            end
        end
        
        quotient = {divident[31]^divisor[31], exponent[7:0], tmpQuotient[24:2]};
    end
end

endmodule