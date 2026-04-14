module restoring_divider(  
    input clk,  
    input reset,  
    input [7:0] dividend,  
    input [3:0] divisor,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    output reg ready  
);  

    reg [7:0] current_dividend;  
    reg [3:0] current_quotient;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_dividend <= 8'b0;  
            current_quotient <= 4'b0;  
            quotient <= 4'b0;  
            remainder <= 4'b0;  
            ready <= 1'b0;  
        end else begin  
            current_dividend <= dividend;  
            current_quotient <= 4'b0;  
            ready <= 1'b0;  
            remainder <= dividend;  

            for (i = 0; i < 4; i = i + 1) begin  
                remainder = {remainder[6:0], 1'b0};  
                current_quotient = {current_quotient[2:0], 1'b1};  

                if (remainder >= {4'b0, divisor}) begin  
                    remainder = remainder - {4'b0, divisor};  
                end else begin  
                    current_quotient = {current_quotient[2:0], 1'b0};  
                end  
            end  
            quotient <= current_quotient;  
            remainder <= remainder[3:0];  
            ready <= 1'b1;  
        end  
    end  
endmodule