module top_module( 
    input a, 
    input b, 
    output out );wire nand1_out, nand2_out, nand3_out;
    
    nand nand1( nand1_out, a, a ); // Corrected: using positional port mapping
    nand nand2( nand2_out, b, b ); // Corrected: using positional port mapping
    nand nand3( nand3_out, nand1_out, nand2_out ); // Corrected: using positional port mapping
    
    not not1( out, nand3_out ); // Corrected: using positional port mapping
    
endmodule