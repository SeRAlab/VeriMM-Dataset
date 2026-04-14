module top_module(clk, state, key, out, m1__DOT__aes_128_i__DOT__out_reg);output [127:0] m1__DOT__aes_128_i__DOT__out_reg;
    input          clk;
    input  [127:0] state, key;
    output [127:0] out;
    (* keep *)reg [127:0] out_reg;
    assign out = ~out_reg; 
    
    
    

 assign m1__DOT__aes_128_i__DOT__out_reg = out_reg;endmodule