module divider_8bit (  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder  
);  

    always @(*) begin  
        if (divisor == 8'b0) begin  
            quotient = 8'b11111111; // Error code for division by zero  
            remainder = 8'b11111111; // Error code for division by zero  
        end else begin  
            quotient = dividend / divisor;  
            remainder = dividend % divisor;  
        end  
    end  
endmodule