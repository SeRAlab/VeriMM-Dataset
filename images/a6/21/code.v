module top_module(
    Q     ,
    Q_N   ,
    D     
);output Q     ;
    output Q_N   ;
    input  D     ;

    assign Q = D;
    assign Q_N = ~D;

endmodule