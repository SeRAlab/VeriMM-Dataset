module nor_using_nand( 
    input a, 
    input b, 
    output out );

    wire nand1_out;
    wire nand2_out;
    wire nand3_out;

    // Implementing NOR using NAND gates
    nand nand1( .a(a), .b(a), .out(nand1_out) );
    nand nand2( .a(b), .b(b), .out(nand2_out) );
    nand nand3( .a(nand1_out), .b(nand2_out), .out(out) );

endmodule