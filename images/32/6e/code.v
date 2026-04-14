module phase_shifter (  
    input [2:0] in,  
    output [2:0] out  
);  
    assign out = {in[1:0], in[2]};  
endmodule