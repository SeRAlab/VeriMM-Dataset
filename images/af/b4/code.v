module top_module( 
    input a, 
    input b, 
    input cin,
    output cout, 
    output sum,
    output out );// Half Adder
    wire ha_sum, ha_carry;
    xor(ha_sum, a, b);
    and(ha_carry, a, b);
    
    // XNOR Gate using NAND gates
    wire xnor_out;
    nand(xnor_out, a, b);
    nand(xnor_out, xnor_out, xnor_out);
    nand(xnor_out, xnor_out, xnor_out);
    
    // Final Output Module
    assign sum = ha_sum;
    assign cout = ha_carry;
    assign out = (ha_carry == 1'b0) ? xnor_out : ha_sum;
    
endmodule