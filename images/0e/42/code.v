module xor5(input [4:0] a, output y);  
    assign y = a[0] ^ a[1] ^ a[2] ^ a[3] ^ a[4];  
endmodule