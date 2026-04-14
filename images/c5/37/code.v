module my_nand3 (output o, input i0, i1, i2);
    wire nand1, nand2;
    
    assign nand1 = ~(i0 & i1);
    assign nand2 = ~(nand1 & i2);
    
    assign o = nand2;
endmodule