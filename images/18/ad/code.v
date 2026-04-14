module huffman_encoder(input [15:0] frequencies, output reg [15:0] codes);  
    always @(*) begin  
        // Initialize output codes  
        codes = 16'b0;  
        
        // Simple Huffman encoding based on predefined structure  
        // This is just an example for illustration; actual Huffman coding would need a tree  
        if (frequencies[1:0] > frequencies[3:2]) begin  
            codes[1:0] = 2'b00; // Code for char 0  
        end else begin  
            codes[1:0] = 2'b01; // Code for char 1  
        end  
        
        if (frequencies[5:4] > frequencies[7:6]) begin  
            codes[3:2] = 2'b00; // Code for char 2  
        end else begin  
            codes[3:2] = 2'b01; // Code for char 3  
        end  
        
        if (frequencies[9:8] > frequencies[11:10]) begin  
            codes[5:4] = 2'b00; // Code for char 4  
        end else begin  
            codes[5:4] = 2'b01; // Code for char 5  
        end  
        
        if (frequencies[13:12] > frequencies[15:14]) begin  
            codes[7:6] = 2'b00; // Code for char 6  
        end else begin  
            codes[7:6] = 2'b01; // Code for char 7  
        end  
    end  
endmodule