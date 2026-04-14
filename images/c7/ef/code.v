module mux2to1 (
    in1 ,
    in2 ,
    sel ,
    out ,
    vpwr,
    vgnd
);

    output out ;
    input  in1 ;
    input  in2 ;
    input  sel ;
    input  vpwr;
    input  vgnd;

    assign out = sel ? in2 : in1;

endmodule