module mux8to1(  
    input [7:0] in,  
    input [2:0] sel,  
    output out  
);  
    assign out = in[sel];  
endmodule