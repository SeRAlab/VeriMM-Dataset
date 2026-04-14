module top_module( 
    input a, 
    input b, 
    output out );wire nand1, nand2, nand3, nand4;
    
    assign nand1 = ~(a & b);
    assign nand2 = ~(a & nand1);
    assign nand3 = ~(b & nand1);
    assign nand4 = ~(nand2 & nand3);
    
    assign out = nand4;
    
endmodule