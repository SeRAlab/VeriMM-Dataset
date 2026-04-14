module chacha20_quarter_round (
    input [31:0] a, b, c, d,
    output reg [31:0] out_a, out_b, out_c, out_d
);
    always @* begin
        out_a = a + b; 
        out_d = (out_a ^ (out_a >> 16)); 
        out_c = c + out_d; 
        out_b = (out_c ^ (out_c >> 12)); 
        out_a = out_a + out_b; 
        out_d = (out_a ^ (out_a >> 8)); 
        out_c = out_c + out_d; 
        out_b = (out_c ^ (out_c >> 7)); 
    end
endmodule