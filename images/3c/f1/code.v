module quarter_round (
    input  [31:0] input_a,
    input  [31:0] input_b,
    input  [31:0] input_c,
    input  [31:0] input_d,
    output reg [31:0] output_a,
    output reg [31:0] output_b,
    output reg [31:0] output_c,
    output reg [31:0] output_d
);
    reg [31:0] a, b, c, d;

    always @* begin
        // First round
        a = input_a + input_b;
        d = input_d ^ a;
        d = {d[15:0], d[31:16]}; // Rotate left by 16
        // Second round
        c = input_c + d;
        b = input_b ^ c;
        b = {b[19:0], b[31:20]}; // Rotate left by 12
        // Third round
        a = a + b;
        d = d ^ a;
        d = {d[23:0], d[31:24]}; // Rotate left by 8
        // Fourth round
        c = c + d;
        b = b ^ c;
        b = {b[24:0], b[31:25]}; // Rotate left by 7
        
        output_a = a;
        output_b = b;
        output_c = c;
        output_d = d;
    end
endmodule