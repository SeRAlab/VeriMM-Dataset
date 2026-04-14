module top_module(I, O);input [3:0] I;
    output [3:0] O;
    wire [3:0] Or, Ir;
    
    assign Or[0] = Ir[0] ^ (Ir[1] & Ir[2] & Ir[3]);
    assign Or[1] = Ir[1] ^ (Ir[2] & Ir[3]);
    assign Or[2] = Ir[2] ^ Ir[3];
    assign Or[3] = ~Ir[3];
    assign O = {Or[0], Or[1], Or[2], Or[3]};
    assign Ir = {I[0], I[1], I[2], I[3]};
endmodule