module sr_latch (  
    input wire S,  
    input wire R,  
    output wire Q,  
    output wire Qn  
);  
    wire nand1_out, nand2_out;  
    nand (nand1_out, S, Qn);  
    nand (nand2_out, R, Q);  
    assign Q = nand1_out;  
    assign Qn = nand2_out;  
endmodule