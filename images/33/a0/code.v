module rs_encoder (  
    input [3:0] data,  
    output reg [6:0] encoded  
);  
    always @* begin  
        // Initialize the encoded output  
        encoded = 0;  
        // Perform encoding based on Reed-Solomon  
        encoded[3:0] = data; // data is directly assigned to the first 4 bits  
        encoded[4] = data[0] ^ data[1]; // Example error correction bits  
        encoded[5] = data[1] ^ data[2]; // Example error correction bits  
        encoded[6] = data[2] ^ data[3]; // Example error correction bits  
    end  
endmodule