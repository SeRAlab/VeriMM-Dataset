module top_module(
    
    output reg Q, 
    output wire notQ, 
    input wire D, En 
    );always@(En or D)
        if(En) 
            Q = D; 
    assign notQ = ~Q; 
endmodule