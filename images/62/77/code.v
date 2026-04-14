module top_module(
    input DATA, LATCH,
    output Q, QNOT
    );wire d, l;
    reg q, qnot;
    
    assign d = DATA;
    assign l = LATCH;
    
    always@(d or l)
        if(l)begin
            q <= d;
            qnot <= ~d;
        end
    
    assign Q = q;
    assign QNOT = qnot;endmodule