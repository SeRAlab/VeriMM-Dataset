module top_module(
    in_0,
    in_1,
    sel,
    out
);input in_0;
    input in_1;
    input sel;
    output out;
    
    assign out = sel ? in_1 : in_0;
    
endmodule