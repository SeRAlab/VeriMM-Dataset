module chacha20_quarter_round (
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    output [31:0] out_a,
    output [31:0] out_b,
    output [31:0] out_c,
    output [31:0] out_d
);
    wire [31:0] temp_a, temp_b, temp_c, temp_d;
    
    assign temp_a = a + b; 
    assign temp_d = d ^ temp_a;
    assign temp_d = {temp_d[23:0], temp_d[31:24]}; // Rotate left by 16
    
    assign temp_b = b + temp_d; 
    assign temp_c = c ^ temp_b;
    assign temp_c = {temp_c[15:0], temp_c[31:16]}; // Rotate left by 12
    
    assign temp_a = temp_a + temp_c; 
    assign temp_d = d ^ temp_a;
    assign temp_d = {temp_d[7:0], temp_d[31:8]}; // Rotate left by 8
    
    assign temp_b = temp_b + temp_d; 
    assign temp_c = c ^ temp_b;
    assign temp_c = {temp_c[31:24], temp_c[23:0]}; // Rotate left by 7
    
    assign out_a = temp_a;
    assign out_b = temp_b;
    assign out_c = temp_c;
    assign out_d = temp_d;
endmodule