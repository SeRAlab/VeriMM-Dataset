module non_restoring_divider(  
    input [3:0] dividend,  
    input [3:0] divisor,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder  
);  
    integer i;  
    reg [7:0] temp;  
    reg [3:0] divisor_sign;  
    initial begin  
        quotient = 4'b0000;  
        remainder = 4'b0000;  
    end  
    always @(*) begin  
        temp = {4'b0000, dividend};  
        divisor_sign = divisor;  
        quotient = 4'b0000;  
        for (i = 0; i < 4; i = i + 1) begin  
            temp = {temp[6:0], 1'b0};  
            if (temp[7:4] >= divisor_sign) begin  
                temp[7:4] = temp[7:4] - divisor_sign;  
                quotient[i] = 1'b1;  
            end else begin  
                quotient[i] = 1'b0;  
            end  
        end  
        remainder = temp[7:4];  
    end  
endmodule