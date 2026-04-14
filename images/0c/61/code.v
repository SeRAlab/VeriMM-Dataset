module aes_round (
    input wire clk,
    input wire reset,
    input wire [127:0] data_in,       // 128-bit input data
    input wire [127:0] round_key,     // 128-bit round key
    output reg [127:0] data_out       // 128-bit output data
);

    reg [127:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 128'b0;
            data_out <= 128'b0;
        end else begin
            // SubBytes operation (simple substitution)
            state[127:120] <= data_in[127:120] ^ round_key[127:120];
            state[119:112] <= data_in[119:112] ^ round_key[119:112];
            state[111:104] <= data_in[111:104] ^ round_key[111:104];
            state[103:96]  <= data_in[103:96] ^ round_key[103:96];
            state[95:88]   <= data_in[95:88] ^ round_key[95:88];
            state[87:80]   <= data_in[87:80] ^ round_key[87:80];
            state[79:72]   <= data_in[79:72] ^ round_key[79:72];
            state[71:64]   <= data_in[71:64] ^ round_key[71:64];
            state[63:56]   <= data_in[63:56] ^ round_key[63:56];
            state[55:48]   <= data_in[55:48] ^ round_key[55:48];
            state[47:40]   <= data_in[47:40] ^ round_key[47:40];
            state[39:32]   <= data_in[39:32] ^ round_key[39:32];
            state[31:24]   <= data_in[31:24] ^ round_key[31:24];
            state[23:16]   <= data_in[23:16] ^ round_key[23:16];
            state[15:8]    <= data_in[15:8] ^ round_key[15:8];
            state[7:0]     <= data_in[7:0] ^ round_key[7:0];

            // Assign the processed state to output
            data_out <= state;
        end
    end
endmodule