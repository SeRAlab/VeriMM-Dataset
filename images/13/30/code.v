module chacha20_quarter_round(  
    input clk,  
    input rst,  
    input [31:0] a,  
    input [31:0] b,  
    input [31:0] c,  
    input [31:0] d,  
    output reg [31:0] out_a,  
    output reg [31:0] out_b,  
    output reg [31:0] out_c,  
    output reg [31:0] out_d  
);  
    reg [31:0] a_reg, b_reg, c_reg, d_reg;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out_a <= 32'b0;  
            out_b <= 32'b0;  
            out_c <= 32'b0;  
            out_d <= 32'b0;  
        end else begin  
            a_reg <= a;  
            b_reg <= b;  
            c_reg <= c;  
            d_reg <= d;  
            // First step  
            a_reg <= a_reg + b_reg;  
            d_reg <= d_reg ^ a_reg;  
            d_reg <= (d_reg << 16) | (d_reg >> (32 - 16));  
            // Second step  
            c_reg <= c_reg + d_reg;  
            b_reg <= b_reg ^ c_reg;  
            b_reg <= (b_reg << 12) | (b_reg >> (32 - 12));  
            // Third step  
            a_reg <= a_reg + b_reg;  
            d_reg <= d_reg ^ a_reg;  
            d_reg <= (d_reg << 8) | (d_reg >> (32 - 8));  
            // Fourth step  
            c_reg <= c_reg + d_reg;  
            b_reg <= b_reg ^ c_reg;  
            b_reg <= (b_reg << 7) | (b_reg >> (32 - 7));  
            // Assign outputs  
            out_a <= a_reg;  
            out_b <= b_reg;  
            out_c <= c_reg;  
            out_d <= d_reg;  
        end  
    end  
endmodule