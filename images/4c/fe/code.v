module top_module(
    Y   ,
    A   ,
    B   ,
    C   ,
    D   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire w1, w2, w3;

    // Define a simple NOR gate implementation
    function nor_gate;
        input a, b;
        begin
            nor_gate = ~(a | b);
        end
    endfunction
    
    assign w1 = nor_gate(A, B);
    assign w2 = nor_gate(C, D);
    assign w3 = nor_gate(w1, w2);
    
    assign Y = w3;

endmodule