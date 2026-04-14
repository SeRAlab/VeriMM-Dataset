module SRT_Divider(  
    input [3:0] numerator,  
    input [3:0] denominator,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder  
);  
    always @(*) begin  
        if (denominator == 0) begin  
            quotient = 4'b0000;  
            remainder = 4'b0000;  
        end else begin  
            // Simple SRT division approximation logic  
            quotient = numerator / denominator;  
            remainder = numerator % denominator;  
        end  
    end  
endmodule