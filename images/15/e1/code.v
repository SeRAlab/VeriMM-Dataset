module divider_8bit (  
    input clk,  
    input reset,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg ready  
);  

    reg [7:0] temp_dividend, temp_divisor;  
    reg [7:0] count;  
    reg [7:0] result;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            ready <= 0;  
            count <= 8'b0;  
        end else begin  
            if (count < 8) begin  
                if (count == 0) begin  
                    temp_dividend <= dividend;  
                    temp_divisor <= divisor;  
                    if (divisor == 8'b0) begin  
                        quotient <= 8'b11111111;  
                        remainder <= 8'b11111111;  
                        ready <= 1;  
                    end else begin  
                        result <= 0;  
                    end  
                end else begin  
                    temp_dividend = {temp_dividend[6:0], 1'b0};  
                    if (temp_dividend >= temp_divisor) begin  
                        temp_dividend = temp_dividend - temp_divisor;  
                        result = {result[6:0], 1'b1};  
                    end else begin  
                        result = {result[6:0], 1'b0};  
                    end  
                end  
                count <= count + 1;  
            end else begin  
                quotient <= result;  
                remainder <= temp_dividend;  
                ready <= 1;  
            end  
        end  
    end  
endmodule