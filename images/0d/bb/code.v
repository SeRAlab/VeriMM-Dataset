module sha256 (  
    input clk,  
    input reset,  
    input [255:0] data_in,  
    output reg [255:0] hash_out  
);  

    reg [511:0] padded_data;  
    reg [255:0] hash;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            hash <= 256'h6a09e667bb67ae858a3f1a8c27c3f3b4; // Initial hash value  
            padded_data <= 0;  
            hash_out <= 0;  
        end else begin  
            // Simple padding and processing
            padded_data <= {data_in, 1'b1, {447{1'b0}}, data_in[255:224]}; // Simplified padding  
            for (i = 0; i < 64; i = i + 1) begin  
                // Simple Example of updating hash (not a complete SHA-256 implementation)
                hash <= hash + padded_data[i*8 +: 8];  
            end  
            hash_out <= hash;  
        end  
    end  
endmodule