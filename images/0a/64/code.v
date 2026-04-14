module divider_8bit (  
    input clk,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg error  
);  
    always @(posedge clk) begin  
        if (divisor == 8'b0) begin  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            error <= 1'b1;  
        end else begin  
            quotient <= dividend / divisor;  
            remainder <= dividend % divisor;  
            error <= 1'b0;  
        end  
    end  
endmodule