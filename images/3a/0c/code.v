module non_restoring_divider (  
    input [7:0] DIVIDEND,  
    input [7:0] DIVISOR,  
    output reg [7:0] QUOTIENT,  
    output reg [7:0] REMAINDER  
);  
    integer i;  
    reg [8:0] temp;  
    always @(*) begin  
        if (DIVISOR == 0) begin  
            QUOTIENT = 8'b0;  
            REMAINDER = DIVIDEND;  
        end else begin  
            temp = {1'b0, DIVIDEND};  
            QUOTIENT = 0;  
            REMAINDER = 0;  
            for (i = 0; i < 8; i = i + 1) begin  
                temp = temp << 1;  
                REMAINDER = temp[8:1] - DIVISOR;  
                if (REMAINDER[8]) begin  
                    temp[0] = 0;  
                    REMAINDER = temp[8:1];  
                end else begin  
                    temp[0] = 1;  
                    REMAINDER = REMAINDER[7:0];  
                end  
                QUOTIENT = (QUOTIENT << 1) | temp[0];  
            end  
        end  
    end  
endmodule