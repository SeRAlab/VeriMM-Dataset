module chacha_quarter_round(  
    input wire [31:0] a,  
    input wire [31:0] b,  
    input wire [31:0] c,  
    input wire [31:0] d,  
    output reg [31:0] out_a,  
    output reg [31:0] out_b,  
    output reg [31:0] out_c,  
    output reg [31:0] out_d  
);  
    always @* begin  
        out_a = a + b;  
        out_b = {out_a[15:0], out_a[31:16]} + c;  
        out_c = {out_b[19:0], out_b[31:20]} + d;  
        out_d = {out_c[23:0], out_c[31:24]} + a;  
    end  
endmodule