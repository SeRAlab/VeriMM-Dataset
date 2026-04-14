module top_module(input a, b, c, d, output out);wire temp1, temp2, temp3;
    
    nand gate1(temp1, a, b);
    nand gate2(temp2, temp1, c);
    nand gate3(temp3, temp2, d);
    nand gate4(out, temp3, temp3);
    
endmodule