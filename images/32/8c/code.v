module chacha20_quarter_round (
    input wire clk,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [31:0] d,
    output reg [31:0] a_out,
    output reg [31:0] b_out,
    output reg [31:0] c_out,
    output reg [31:0] d_out
);
    reg [31:0] a_reg, b_reg, c_reg, d_reg;

    always @(posedge clk) begin
        // Load inputs into registers
        a_reg <= a;
        b_reg <= b;
        c_reg <= c;
        d_reg <= d;

        // Perform the quarter round operations
        a_reg <= a_reg + b_reg; 
        d_reg <= d_reg ^ (a_reg << 16);
        
        c_reg <= c_reg + d_reg; 
        b_reg <= b_reg ^ (c_reg << 12);
        
        a_reg <= a_reg + b_reg; 
        d_reg <= d_reg ^ (a_reg << 8);
        
        c_reg <= c_reg + d_reg; 
        b_reg <= b_reg ^ (c_reg << 7);
        
        // Assign outputs
        a_out <= a_reg;
        b_out <= b_reg;
        c_out <= c_reg;
        d_out <= d_reg;
    end
endmodule