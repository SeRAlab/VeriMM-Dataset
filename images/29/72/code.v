module aes_round_transform (
    input wire clk,
    input wire reset,
    input wire [127:0] state,    // 128-bit input state
    input wire [127:0] round_key, // 128-bit round key
    output reg [127:0] out        // 128-bit output after AddRoundKey
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 128'b0; // Reset output to 0
    end else begin
        out <= state ^ round_key; // AddRoundKey operation
    end
end

endmodule