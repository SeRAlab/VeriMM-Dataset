module top_module( 
    input a, b,
    output sum, cout );wire p1, p2, p3, p4, p5, p6, p7;
    wire s1, s2, s3, s4, s5, s6;
    
    nand n1(p1, a, b);
    nand n2(p2, a, p1);
    nand n3(p3, p1, b);
    nand n4(p4, p2, p3);
    nand n5(p5, p4, p4);
    nand n6(p6, p5, p5);
    nand n7(p7, p6, p6);
    nand n8(s1, a, p5);
    nand n9(s2, b, p5);
    nand n10(s3, p5, p5);
    nand n11(s4, p6, s1);
    nand n12(s5, s2, s3);
    nand n13(s6, s4, s5);
    
    assign sum = s6;
    assign cout = p7;
    
endmodule