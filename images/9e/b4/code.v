module top_module(
    input [31:0] a,
    input [31:0] b,
    input [1:0] select,
    input [3:0] in,
    output reg [31:0] result,
    output reg [1:0] pos
);reg [63:0] m;
reg [63:0] q;
reg [31:0] a_reg;
reg [31:0] b_reg;
reg [31:0] quotient;
reg [31:0] remainder;
reg [5:0] i;
reg [1:0] highest_bit;

always @(*) begin
    a_reg = a;
    b_reg = b;
    m = {a_reg, 32'b0};
    q = {b_reg, 32'b0};
    quotient = 0;
    remainder = 0;
    highest_bit = 0;
    
    for (i = 0; i < 32; i = i + 1) begin
        if (q[0] == 1 && remainder[0] == 0) begin
            remainder = remainder - m;
        end
        else if (q[0] == 0 && remainder[0] == 1) begin
            remainder = remainder + m;
        end
        
        q = q >> 1;
        q[31] = remainder[63];
        remainder = remainder << 1;
        quotient = quotient << 1;
        quotient[0] = q[31];
    end
    
    if (select == 0) begin
        result = quotient;
    end
    else begin
        result = remainder;
    end
    
    if (in[3] == 1) begin
        highest_bit = 3;
    end
    else if (in[2] == 1) begin
        highest_bit = 2;
    end
    else if (in[1] == 1) begin
        highest_bit = 1;
    end
    else if (in[0] == 1) begin
        highest_bit = 0;
    end
    
    pos = highest_bit;
end

endmodule