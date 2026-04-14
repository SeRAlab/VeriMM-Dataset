module top_module( 
    input a, 
    input b, 
    output out );wire nand1_out, nand2_out, nand3_out;
    
    // Implementing NOR using NAND gates
    nand nand1( nand1_out, a, a );  // Corrected port connections
    nand nand2( nand2_out, b, b );  // Corrected port connections
    nand nand3( nand3_out, nand1_out, nand2_out );  // Corrected port connections
    
    // Inverting the output of the NAND gate to get NOR output
    not not1( out, nand3_out );  // Corrected port connections
    
endmodule