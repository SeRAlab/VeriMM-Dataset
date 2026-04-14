module quarter_round(  
    input clk,  
    input reset,  
    input [31:0] a,  
    input [31:0] b,  
    input [31:0] c,  
    input [31:0] d,  
    output reg [31:0] a_out,  
    output reg [31:0] b_out,  
    output reg [31:0] c_out,  
    output reg [31:0] d_out  
);  
    reg [31:0] a_reg, b_reg, c_reg, d_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            a_out <= 0;  
            b_out <= 0;  
            c_out <= 0;  
            d_out <= 0;  
        end else begin  
            a_reg <= a;  
            b_reg <= b;  
            c_reg <= c;  
            d_reg <= d;  

            // Quarter round operations  
            a_reg <= a_reg + b_reg;  
            d_reg <= d_reg ^ a_reg;  
            d_reg <= d_reg << 16;  
            c_reg <= c_reg + d_reg;  
            b_reg <= b_reg ^ c_reg;  
            b_reg <= b_reg << 12;  
            a_reg <= a_reg + b_reg;  
            d_reg <= d_reg ^ a_reg;  
            d_reg <= d_reg << 8;  
            c_reg <= c_reg + d_reg;  
            b_reg <= b_reg ^ c_reg;  
            b_reg <= b_reg << 7;  

            // Output results  
            a_out <= a_reg;  
            b_out <= b_reg;  
            c_out <= c_reg;  
            d_out <= d_reg;  
        end  
    end  
endmodule