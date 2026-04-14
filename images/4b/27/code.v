module top_module(  output Out, input D0, D1, D2, D3, s0, s1 );assign Out = s1? (s0 ? D3: D1) : (s0? D1:D0);

endmodule