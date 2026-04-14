module restoring_divider (  
    input clk,  
    input rst,  
    input [3:0] D,  // Dividend  
    input [3:0] S,  // Divisor  
    output reg [3:0] Q,  // Quotient  
    output reg [3:0] R   // Remainder  
);  
    reg [3:0] remainder;  
    reg [3:0] divisor;  
    reg [3:0] quotient;  
    reg [2:0] count;  
    reg state;  // 0: idle, 1: dividing  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            Q <= 4'b0000;  
            R <= 4'b0000;  
            count <= 3'b000;  
            state <= 0;  
        end else if (state == 0) begin  
            remainder <= D;  
            divisor <= S;  
            quotient <= 4'b0000;  
            count <= 3'b100;  // Start with 4 bits  
            state <= 1;  
        end else if (state == 1 && count > 0) begin  
            remainder = {remainder[2:0], 1'b0};  // Shift left  
            quotient = {quotient[2:0], 1'b0};    // Shift left  

            if (remainder >= divisor) begin  
                remainder = remainder - divisor;  
                quotient[0] = 1'b1;  
            end  

            count = count - 1;  
            if (count == 0) begin  
                Q <= quotient;  
                R <= remainder;  
                state <= 0;  // Go back to idle  
            end  
        end  
    end  
endmodule