module nand_logic (input A, input B, input C, output Y);  
    wire n1, n2, n3, n4;  
    assign n1 = ~(A & B);  
    assign n2 = ~(A & C);  
    assign n3 = ~(B & C);  
    assign n4 = ~(n1 & n2 & n3);  
    assign Y = ~n4;  
endmodule