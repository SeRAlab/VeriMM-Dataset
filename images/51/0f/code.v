module top_module(
    input [31:0] data,
    input [31:0] key,
    output [31:0] encrypted
);reg [7:0] data_chunks [0:3];
    reg [7:0] key_chunks [0:3];
    reg [31:0] encrypted_chunks;
    
    // Split data into 8-bit chunks
    always @(*) begin
        data_chunks[0] = data[7:0];
        data_chunks[1] = data[15:8];
        data_chunks[2] = data[23:16];
        data_chunks[3] = data[31:24];
    end
    
    // Split key into 8-bit chunks
    always @(*) begin
        key_chunks[0] = key[7:0];
        key_chunks[1] = key[15:8];
        key_chunks[2] = key[23:16];
        key_chunks[3] = key[31:24];
    end
    
    // XOR each 8-bit chunk of data with corresponding 8-bit chunk of key
    always @(*) begin
        encrypted_chunks = {8'd0, 8'd0, 8'd0, 8'd0};
        encrypted_chunks[7:0] = data_chunks[0] ^ key_chunks[0];
        encrypted_chunks[15:8] = data_chunks[1] ^ key_chunks[1];
        encrypted_chunks[23:16] = data_chunks[2] ^ key_chunks[2];
        encrypted_chunks[31:24] = data_chunks[3] ^ key_chunks[3];
    end
    
    assign encrypted = encrypted_chunks;

endmodule