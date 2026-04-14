module srt_divider(  
    input [7:0] numerator,  
    input [7:0] denominator,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder  
);  
    always @(*) begin  
        if (denominator == 8'b00000000) begin  
            quotient = 8'b11111111; // Error case: denominator = 0  
            remainder = 8'b11111111; // Error case: denominator = 0  
        end else begin  
            quotient = numerator / denominator;  
            remainder = numerator % denominator;  
        end  
    end  
endmodule