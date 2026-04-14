module AES_round (
    input clk,
    input rst,
    input [127:0] plaintext,
    input [127:0] key,
    output reg [127:0] ciphertext
);
    reg [127:0] state;
    reg [127:0] round_key;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 128'b0;
            ciphertext <= 128'b0;
        end else begin
            // AddRoundKey
            round_key <= key;
            state <= plaintext ^ round_key;

            // SubBytes (simplified, normally uses S-box)
            state[127:120] <= state[127:120] ^ 8'h01; // Example modification
            state[119:112] <= state[119:112] ^ 8'h02;
            state[111:104] <= state[111:104] ^ 8'h03;
            state[103:96] <= state[103:96] ^ 8'h04;
            // ...

            // ShiftRows (simplified)
            state[127:120] <= state[127:120];
            state[119:112] <= state[111:104];
            state[111:104] <= state[103:96];
            state[103:96] <= state[119:112];

            // MixColumns (simplified)
            //...

            // Final output
            ciphertext <= state; 
        end
    end
endmodule