module DES(
    input wire [7:0] data_in,
    input wire [55:0] key,
    input wire mode, // mode = 0 for encrypt, mode = 1 for decrypt
    output reg [7:0] data_out
);
    // Simplified DES operation for example purposes
    always @(data_in, key, mode) begin
        if (mode == 0) begin
            // Example encryption logic (not real DES)
            data_out = data_in ^ key[7:0]; // XOR with first 8 bits of key
        end else begin
            // Example decryption logic (not real DES)
            data_out = data_in ^ key[7:0]; // XOR with first 8 bits of key
        end
    end
endmodule