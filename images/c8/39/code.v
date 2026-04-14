module logic_unit (
    input a,
    input b,
    input c,
    output x
);

    wire ab = a & b;
    wire ac = a & c;
    wire bc = b & c;
    
    assign x = ab | ac | bc;
    
endmodule