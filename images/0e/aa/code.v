module xnor4(input wire a, input wire b, input wire c, input wire d, output wire y);  
    assign y = ~(a ^ b ^ c ^ d);  
endmodule