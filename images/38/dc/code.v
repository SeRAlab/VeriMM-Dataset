module aes_round (
    input wire [127:0] data_in,
    input wire [127:0] key,
    output reg [127:0] data_out
);
    // SubBytes lookup table
    reg [7:0] sbox [0:255];
    initial begin
        // Initialize S-Box (this is a shortened version; the full S-Box should be initialized)
        sbox[8'h00] = 8'h63; sbox[8'h01] = 8'h7c; // ... (complete S-Box initialization)
    end

    // ShiftRows operation
    function [127:0] shift_rows;
        input [127:0] state;
        begin
            shift_rows = {state[127:120], state[95:88], state[63:56], state[31:24], 
                          state[119:112], state[87:80], state[55:48], state[23:16], 
                          state[111:104], state[79:72], state[47:40], state[15:8], 
                          state[103:96], state[71:64], state[39:32], state[7:0]};
        end
    endfunction

    // AddRoundKey operation
    function [127:0] add_round_key;
        input [127:0] state;
        input [127:0] round_key;
        begin
            add_round_key = state ^ round_key;
        end
    endfunction

    // MixColumns operation (simplified for first round)
    function [127:0] mix_columns;
        input [127:0] state;
        begin
            // Implement the MixColumns operation as per AES specification (simplified)
            // Here we apply transformation for columns
            mix_columns[127:120] = state[127:120] ^ state[119:112] ^ state[111:104];
            mix_columns[119:112] = state[119:112] ^ state[111:104] ^ state[103:96];
            mix_columns[111:104] = state[111:104] ^ state[103:96] ^ state[95:88];
            mix_columns[103:96] = state[103:96] ^ state[95:88] ^ state[127:120];
            // ... repeat for all columns
        end
    endfunction

    always @(*) begin
        data_out = mix_columns(shift_rows(sbox[data_in]));
        data_out = add_round_key(data_out, key);
    end
endmodule