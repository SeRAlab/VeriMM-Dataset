module srt_divider(input [3:0] numerator,  
                    input [3:0] denominator,  
                    output reg [3:0] quotient,  
                    output reg remainder);  
                    
    always @(*) begin  
        if (denominator != 0) begin  
            quotient = numerator / denominator;  
            remainder = numerator % denominator;  
        end else begin  
            quotient = 4'b0000;  
            remainder = 1'b0;  
        end  
    end  
endmodule