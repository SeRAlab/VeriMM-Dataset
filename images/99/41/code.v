module top_module(
    input R,
    input S,
    output QN,
    output Q
    );wire NOR1, NOR2;
    
    assign #1 NOR1 = ~(R | NOR2);
    assign #1 NOR2 = ~(S | NOR1);
    assign Q = NOR1;
    assign QN = NOR2; 
endmodule