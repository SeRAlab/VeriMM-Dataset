module xnor4(input [3:0] a, output y);  
    assign y = ~(a[0] ^ a[1] ^ a[2] ^ a[3]);  
endmodule