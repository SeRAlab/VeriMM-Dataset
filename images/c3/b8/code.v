module half_adder_nand( 
    input a, b,
    output sum, cout );
    
    wire s1, s2, c1;
    
    nand(s1, a, b);
    nand(s2, a, s1);
    nand(c1, s1, b);
    
    assign sum = s2;
    assign cout = c1;
    
endmodule