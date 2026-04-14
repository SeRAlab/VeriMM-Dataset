module mux_2to1(
    input sel,
    input in0,
    input in1,
    output out
    );
    
    wire not_sel;
    assign not_sel = ~sel;
    
    wire and0;
    assign and0 = in0 & not_sel;
    
    wire and1;
    assign and1 = in1 & sel;
    
    assign out = and0 | and1;
    
endmodule