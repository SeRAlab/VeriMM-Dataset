module hamming_encoder (  
    input [3:0] data,  
    output [6:0] encoded  
);  
    wire p1, p2, p3;  

    // Calculate parity bits  
    assign p1 = data[0] ^ data[1] ^ data[3];  
    assign p2 = data[0] ^ data[2] ^ data[3];  
    assign p3 = data[1] ^ data[2] ^ data[3];  

    // Construct the encoded output  
    assign encoded = {p1, p2, data[0], p3, data[1], data[2], data[3]};  
endmodule