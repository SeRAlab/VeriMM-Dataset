module aes_round (
    input wire clk,
    input wire rst,
    input wire [127:0] state_in,
    input wire [127:0] round_key,
    output reg [127:0] state_out
);

    // S-box for AES
    reg [7:0] s_box [0:255];
    initial begin
        // S-box initialization (values omitted for brevity)
        // s_box[0] = 8'h63; s_box[1] = 8'h7c; ...;
    end

    wire [127:0] s_box_out;
    wire [127:0] add_key_out;

    // SubBytes (S-box substitution)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin: sub_bytes
            assign s_box_out[i*8 +: 8] = s_box[state_in[i*8 +: 8]];
        end
    endgenerate

    // AddRoundKey
    assign add_key_out = s_box_out ^ round_key;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_out <= 128'h0;
        end else begin
            state_out <= add_key_out;
        end
    end
endmodule