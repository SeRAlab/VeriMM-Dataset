module and_gate(  
    input wire a,  
    input wire b,  
    input wire c,  
    input wire d,  
    output wire y,  
    output wire [1:0] count  
);  

assign y = a & b & c & d;  
assign count = a + b + c + d;  

endmodule