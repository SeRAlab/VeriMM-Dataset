module aes_key_gen (
    input  [127:0] key_in,
    output [127:0] round_key
);
    
    wire [127:0] rotated_key;
    wire [127:0] substituted_key;
    
    // Rotate the key
    assign rotated_key = {key_in[119:0], key_in[127:120]};
    
    // Substitute bytes (simple example, can be replaced with an actual S-box)
    assign substituted_key = {rotated_key[127:120] ^ 8'h63,
                              rotated_key[119:112] ^ 8'h7c,
                              rotated_key[111:104] ^ 8'h77,
                              rotated_key[103:96] ^ 8'h7b,
                              rotated_key[95:88]  ^ 8'hf2,
                              rotated_key[87:80]  ^ 8'h6b,
                              rotated_key[79:72]  ^ 8'h6f,
                              rotated_key[71:64]  ^ 8'hc5,
                              rotated_key[63:56]  ^ 8'h30,
                              rotated_key[55:48]  ^ 8'h01,
                              rotated_key[47:40]  ^ 8'h67,
                              rotated_key[39:32]  ^ 8'h2b,
                              rotated_key[31:24]  ^ 8'hfe,
                              rotated_key[23:16]  ^ 8'hd7,
                              rotated_key[15:8]   ^ 8'hab,
                              rotated_key[7:0]    ^ 8'h76};
    
    // Generate the round key
    assign round_key = substituted_key ^ key_in;

endmodule