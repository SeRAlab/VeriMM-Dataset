module hamming_encoder (  
    input [3:0] data,  
    output reg [6:0] encoded  
);  
    always @(*) begin  
        encoded[6] = data[0] ^ data[1] ^ data[3];  // p1  
        encoded[5] = data[0] ^ data[2] ^ data[3];  // p2  
        encoded[4] = data[1] ^ data[2] ^ data[3];  // p3  
        encoded[3] = data[0];  
        encoded[2] = data[1];  
        encoded[1] = data[2];  
        encoded[0] = data[3];  
    end  
endmodule