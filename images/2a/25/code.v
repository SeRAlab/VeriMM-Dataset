module divider_2bit (  
    input [1:0] dividend,  
    input [1:0] divisor,  
    output reg [1:0] quotient,  
    output reg remainder  
);  
    always @(*) begin  
        if (divisor == 2'b00) begin  
            quotient = 2'b00; // Default value for quotient  
            remainder = 1'b0; // Default value for remainder  
        end else begin  
            quotient = dividend / divisor;  
            remainder = dividend % divisor;  
        end  
    end  
endmodule