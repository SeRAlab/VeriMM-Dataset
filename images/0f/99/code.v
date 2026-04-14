module quarter_round (  
    input  [31:0] a,  
    input  [31:0] b,  
    input  [31:0] c,  
    input  [31:0] d,  
    output reg [31:0] o_a,  
    output reg [31:0] o_b,  
    output reg [31:0] o_c,  
    output reg [31:0] o_d,  
    input clk  
);  
    always @(posedge clk) begin  
        o_a <= a + b;  
        o_d <= d ^ o_a;  
        o_b <= o_d + c;  
        o_c <= b ^ o_b;  
        o_a <= o_a + o_c;  
        o_d <= o_c ^ d;  
    end  
endmodule