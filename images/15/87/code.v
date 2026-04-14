module aes_round(input [127:0] state,  
                  input [127:0] round_key,  
                  output reg [127:0] new_state);  
    // SubBytes transformation  
    function [127:0] sub_bytes;  
        input [127:0] in;  
        // AES S-Box lookup (simplified for this example)  
        integer i;  
        reg [7:0] sbox[0:255];  
        begin  
            // Initialize S-Box (only a few entries for example purpose)  
            sbox[8'h00] = 8'h63;  
            sbox[8'h01] = 8'h7c;  
            sbox[8'h02] = 8'h77;  
            // ... (fill in the rest of the S-Box)  
            for (i = 0; i < 16; i = i + 1)  
                sub_bytes[i*8 +: 8] = sbox[in[i*8 +: 8]];  
        end  
    endfunction  

    // ShiftRows transformation  
    function [127:0] shift_rows;  
        input [127:0] in;  
        begin  
            shift_rows[127:120] = in[127:120]; // Row 0  
            shift_rows[119:112] = in[103:96];  // Row 1  
            shift_rows[111:104] = in[79:72];   // Row 2  
            shift_rows[103:96]  = in[55:48];   // Row 3  
        end  
    endfunction  

    // MixColumns transformation  
    function [127:0] mix_columns;  
        input [127:0] in;  
        // Simplified mix-columns for this example  
        begin  
            mix_columns[127:120] = in[127:120] ^ in[119:112];  
            mix_columns[119:112] = in[119:112] ^ in[111:104];  
            mix_columns[111:104] = in[111:104] ^ in[103:96];  
            mix_columns[103:96]  = in[103:96] ^ in[127:120];  
        end  
    endfunction  

    always @(*) begin  
        new_state = add_round_key(mix_columns(shift_rows(sub_bytes(state))), round_key);  
    end  

    function [127:0] add_round_key;  
        input [127:0] in1;  
        input [127:0] in2;  
        begin  
            add_round_key = in1 ^ in2;  
        end  
    endfunction  
endmodule