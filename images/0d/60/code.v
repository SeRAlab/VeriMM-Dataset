module chacha20_quarter_round (  
    input [31:0] a, b, c, d,  
    output [31:0] out_a, out_b, out_c, out_d  
);  
    reg [31:0] a_reg, b_reg, c_reg, d_reg;  
    always @(*) begin  
        a_reg = a + b;  
        d_reg = d ^ a_reg;  
        d_reg = d_reg << 16;  
        c_reg = c + d_reg;  
        b_reg = b ^ c_reg;  
        b_reg = b_reg << 12;  
        a_reg = a_reg + b_reg;  
        d_reg = d_reg ^ a_reg;  
        d_reg = d_reg << 8;  
        c_reg = c_reg + d_reg;  
        b_reg = b_reg ^ c_reg;  
        b_reg = b_reg << 7;  
    end  
    assign out_a = a_reg;  
    assign out_b = b_reg;  
    assign out_c = c_reg;  
    assign out_d = d_reg;  
endmodule