module mux3to1(  
    input wire [2:0] in,  
    input wire [1:0] sel,  
    output wire out  
);  
    assign out = (sel == 2'b00) ? in[0] :  
                 (sel == 2'b01) ? in[1] :  
                 (sel == 2'b10) ? in[2] :  
                 1'b0;  
endmodule