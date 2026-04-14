module SRT_Divider (  
    input [4:0] dividend,  
    input [4:0] divisor,  
    output reg [4:0] quotient,  
    output reg [3:0] remainder  
);  
    always @(*) begin  
        if (divisor == 0) begin  
            quotient = 5'b11111;  // Indicating division by zero  
            remainder = 4'b0000;  
        end else begin  
            quotient = dividend / divisor;  
            remainder = dividend % divisor;  
        end  
    end  
endmodule