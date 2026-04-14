module top_module( 
    input a, 
    input b, 
    output out );wire nand1_out;
    wire nand2_out;
    wire nand3_out;

    // Implementing NOR using NAND gates
    nand nand1( nand1_out, a, a );  // Fixed: added port names
    nand nand2( nand2_out, b, b );  // Fixed: added port names
    nand nand3( out, nand1_out, nand2_out );  // Fixed: added port names

endmodule