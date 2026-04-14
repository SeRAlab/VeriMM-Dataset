module top_module( 
    input a, 
    input b, 
    output out );wire not_a, not_b, nor_out;
    
    // Implementing NOT gates using NOR gates
    nor(nor_out, a, a);
    nor(not_a, nor_out, nor_out);
    
    nor(nor_out, b, b);
    nor(not_b, nor_out, nor_out);
    
    // Implementing AND gate using NOR gates
    nor(out, not_a, not_b);
    
endmodule