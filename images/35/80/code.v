module rs_encoder(  
    input [3:0] data,  
    output reg [7:0] encoded  
);  
    always @(*) begin  
        // Simple encoding logic (for demonstration purposes)  
        encoded[7:4] = data; // 4 bits of data  
        encoded[3:0] = data ^ 4'b1010; // Simple error correction polynomial (X^3 + X + 1)  
    end  
endmodule