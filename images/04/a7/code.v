module chacha20_quarter_round(  
    input wire [31:0] a,  
    input wire [31:0] b,  
    input wire [31:0] c,  
    input wire [31:0] d,  
    output reg [31:0] out_a,  
    output reg [31:0] out_b,  
    output reg [31:0] out_c,  
    output reg [31:0] out_d  
);  
    always @(*) begin  
        out_a = a + b;  
        out_d = d ^ out_a;  
        out_d = (out_d << 16) | (out_d >> (32 - 16));  
        
        out_b = b + out_d;  
        out_c = c ^ out_b;  
        out_c = (out_c << 12) | (out_c >> (32 - 12));  
        
        out_a = out_a + out_c;  
        out_d = out_d ^ out_a;  
        out_d = (out_d << 8) | (out_d >> (32 - 8));  
        
        out_b = out_b + out_d;  
        out_c = out_c ^ out_b;  
        out_c = (out_c << 7) | (out_c >> (32 - 7));  
    end  
endmodule