module chacha20_quarter_round (
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,
    input  [31:0] d,
    output reg [31:0] o_a,
    output reg [31:0] o_b,
    output reg [31:0] o_c,
    output reg [31:0] o_d
);
    always @(*) begin
        o_a = a + b; 
        o_d = d ^ o_a; 
        o_d = o_d << 16 | o_d >> 16;  // Rotate left 16
        o_c = c + o_d; 
        o_b = b ^ o_c; 
        o_b = o_b << 12 | o_b >> 20;  // Rotate left 12
        o_a = o_a + o_b; 
        o_d = d ^ o_a; 
        o_d = o_d << 8 | o_d >> 24;   // Rotate left 8
        o_c = o_c + o_d; 
        o_b = o_b ^ o_c; 
        o_b = o_b << 7 | o_b >> 25;   // Rotate left 7
    end
endmodule