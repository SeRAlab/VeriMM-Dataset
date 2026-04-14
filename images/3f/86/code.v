module divider_8bit (  
    input clk,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg div_by_zero  
);  

    always @(posedge clk) begin  
        if (divisor == 0) begin  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            div_by_zero <= 1;  
        end else begin  
            quotient <= dividend / divisor;  
            remainder <= dividend % divisor;  
            div_by_zero <= 0;  
        end  
    end  
endmodule