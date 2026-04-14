module chacha_quarter_round(  
    input wire [31:0] a,  
    input wire [31:0] b,  
    input wire [31:0] c,  
    input wire [31:0] d,  
    input wire clk,  
    input wire rst,  
    output reg [31:0] a_out,  
    output reg [31:0] b_out,  
    output reg [31:0] c_out,  
    output reg [31:0] d_out  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            a_out <= 0;  
            b_out <= 0;  
            c_out <= 0;  
            d_out <= 0;  
        end else begin  
            a_out <= a + b;  
            d_out <= (d ^ a_out) >> 16 | (d ^ a_out) << 16;  
            c_out <= c + d_out;  
            b_out <= (b ^ c_out) >> 12 | (b ^ c_out) << 20;  
            a_out <= a_out + b_out;  
            d_out <= (d_out ^ a_out) >> 8 | (d_out ^ a_out) << 24;  
            c_out <= c_out + d_out;  
            b_out <= (b_out ^ c_out) >> 7 | (b_out ^ c_out) << 25;  
        end  
    end  
endmodule