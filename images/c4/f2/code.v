module nor_gate_using_nand( 
    input a, 
    input b, 
    output out );
    
    wire nand1_out, nand2_out, nand3_out;
    
    nand nand1( .a(a), .b(a), .out(nand1_out) );
    nand nand2( .a(b), .b(b), .out(nand2_out) );
    nand nand3( .a(nand1_out), .b(nand2_out), .out(nand3_out) );
    
    not not1( .a(nand3_out), .out(out) );
    
endmodule