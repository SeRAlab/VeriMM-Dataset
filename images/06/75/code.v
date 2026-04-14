module divider_4bit (  
    input clk,  
    input [3:0] dividend,  
    input [3:0] divisor,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    output reg valid  
);  
    always @(posedge clk) begin  
        if (divisor == 0) begin  
            quotient <= 4'b0000;  
            remainder <= 4'b0000;  
        end else begin  
            quotient <= dividend / divisor;  
            remainder <= dividend % divisor;  
        end  
        valid <= 1;  
    end  
endmodule