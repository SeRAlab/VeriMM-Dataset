module SRT_Divider(input [3:0] dividend, input [3:0] divisor, output reg [3:0] quotient, output reg [3:0] remainder);  
    reg [3:0] T;  
    integer i;  

    always @(*) begin  
        quotient = 4'b0;  
        remainder = dividend;  
        for (i = 3; i >= 0; i = i - 1) begin  
            T = {remainder[3], remainder} - {1'b0, divisor};  
            if (T[4] == 1'b0) begin  
                remainder = T[3:0];  
                quotient[i] = 1'b1;  
            end else begin  
                quotient[i] = 1'b0;  
            end  
            remainder = {remainder[2:0], 1'b0};  
        end  
    end  
endmodule