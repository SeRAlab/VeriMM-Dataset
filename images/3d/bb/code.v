module divider_4bit (  
    input clk,  
    input enable,  
    input [3:0] dividend,  
    input [3:0] divisor,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            if (divisor != 0) begin  
                quotient <= dividend / divisor;  
                remainder <= dividend % divisor;  
            end else begin  
                quotient <= 4'b0000;  
                remainder <= 4'b0000;  
            end  
        end  
    end  
endmodule