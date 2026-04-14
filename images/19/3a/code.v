module divider_2bit(  
    input clk,  
    input [1:0] dividend,  
    input [1:0] divisor,  
    output reg [1:0] quotient,  
    output reg [1:0] remainder  
);  
    always @(posedge clk) begin  
        if (divisor != 0) begin  
            quotient <= dividend / divisor;  
            remainder <= dividend % divisor;  
        end else begin  
            quotient <= 2'b00;  
            remainder <= 2'b00; // Handling division by zero  
        end  
    end  
endmodule