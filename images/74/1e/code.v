module top_module( 
    input a, 
    input b, 
    output out );wire nand1, nand2, nand3;

    nand n1(a, b, nand1);
    nand n2(a, nand1, nand2);
    nand n3(b, nand1, nand3);
    nand n4(nand2, nand3, out);

endmodule