module quarter_round (
    input wire clk,
    input wire en,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [31:0] d,
    output reg [31:0] out_a,
    output reg [31:0] out_b,
    output reg [31:0] out_c,
    output reg [31:0] out_d
);
    always @(posedge clk) begin
        if (en) begin
            out_a <= a + b; // Add a and b
            out_d <= d ^ out_a; // XOR d with the result of a + b
            out_b <= b + out_d; // Add b and the result of d XOR (a + b)
            out_c <= c ^ out_b; // XOR c with the result of b + (d XOR (a + b))
            out_a <= out_a + out_c; // Add (a + b) and the result of c XOR (b + (d XOR (a + b)))
            out_d <= out_d + out_a; // Final add for d
        end
    end
endmodule