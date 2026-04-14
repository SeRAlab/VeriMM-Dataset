module divider_8bit (  
    input [7:0] numerator,  
    input [7:0] denominator,  
    input clk,  
    input reset,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
        end else begin  
            if (denominator != 8'b0) begin  
                quotient <= numerator / denominator;  
                remainder <= numerator % denominator;  
            end else begin  
                quotient <= 8'b0;  
                remainder <= 8'b0;  
            end  
        end  
    end  
endmodule