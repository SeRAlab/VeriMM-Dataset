module divider_4bit(  
    input clk,  
    input [3:0] dividend,  
    input [3:0] divisor,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    input start,  
    output reg done  
);  
    reg [3:0] count;  
    reg [3:0] tmp_dividend;  
    reg [3:0] tmp_divisor;  
  
    always @(posedge clk) begin  
        if (start) begin  
            if (divisor == 0) begin  
                quotient <= 4'b0000;  
                remainder <= 4'b0000;  
                done <= 1;  
            end else begin  
                count <= 4'b0000;  
                tmp_dividend <= dividend;  
                tmp_divisor <= divisor;  
                quotient <= 4'b0000;  
                remainder <= 4'b0000;  
                done <= 0;  
            end  
        end else if (!done) begin  
            if (tmp_dividend >= tmp_divisor) begin  
                tmp_dividend <= tmp_dividend - tmp_divisor;  
                quotient <= quotient + 1;  
            end else begin  
                remainder <= tmp_dividend;  
                done <= 1;  
            end  
        end  
    end  
endmodule