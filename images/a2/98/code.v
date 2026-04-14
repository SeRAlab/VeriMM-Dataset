module top_module(out, A, B, S);input A, B, S;
    output out;

    assign out = S ? A:B;    
endmodule