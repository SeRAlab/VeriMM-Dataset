module divider_8bit (  
    input clk,  
    input rst,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg valid  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            valid <= 1'b0;  
        end else begin  
            if (divisor != 0) begin  
                quotient <= dividend / divisor;  
                remainder <= dividend % divisor;  
                valid <= 1'b1;  
            end else begin  
                quotient <= 8'b0;  
                remainder <= dividend;  
                valid <= 1'b0;  
            end  
        end  
    end  
endmodule