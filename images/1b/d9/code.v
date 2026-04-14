module divider_8bit (  
    input clk,  
    input start,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] count;  
    reg [7:0] temp_dividend;  
    reg [7:0] temp_quotient;  
    reg state;  

    always @(posedge clk) begin  
        if (start) begin  
            temp_dividend <= dividend;  
            temp_quotient <= 0;  
            count <= 8;  
            done <= 0;  
            state <= 1;  
        end else if (state) begin  
            if (count > 0) begin  
                temp_quotient <= temp_quotient << 1;  
                remainder <= temp_dividend;  
                if (remainder >= divisor) begin  
                    remainder <= remainder - divisor;  
                    temp_quotient[0] <= 1;  
                end  
                temp_dividend <= remainder;  
                count <= count - 1;  
            end else begin  
                quotient <= temp_quotient;  
                remainder <= temp_dividend;  
                done <= 1;  
                state <= 0;  
            end  
        end  
    end  
endmodule