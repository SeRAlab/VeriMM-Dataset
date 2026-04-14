module top_module(sel, D0, D1, Dout);parameter N = 32;
    input wire [N - 1:0] D0, D1;
    input wire sel;
    output wire [N - 1:0] Dout;
    
    assign Dout = sel == 0 ? D0 : D1;

endmodule