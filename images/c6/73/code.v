module mux_2_to_1 (
    //# {{data|Data Signals}}
    input  in1,
    input  in2,
    input  sel,
    output out
);

    assign out = sel ? in2 : in1;

endmodule