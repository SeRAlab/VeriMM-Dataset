module SRT_Divider(  
    input [15:0] dividend,  
    input [15:0] divisor,  
    output reg [15:0] quotient,  
    output reg [15:0] remainder  
);  
    always @(*) begin  
        if (divisor == 0) begin  
            quotient = 16'b0;  
            remainder = 16'b0;  
        end else begin  
            // Initialize quotient and remainder  
            quotient = dividend / divisor;  
            remainder = dividend % divisor;  
        end  
    end  
endmodule