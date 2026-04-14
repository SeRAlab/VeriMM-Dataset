module mux2to1 (  
    input [4:0] a,  
    input [4:0] b,  
    input sel,  
    output [4:0] y  
);  
    assign y = (sel == 1'b0) ? a : b;  
endmodule