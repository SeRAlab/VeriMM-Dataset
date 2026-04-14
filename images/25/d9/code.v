module aes_round (
    input wire clk,
    input wire rst_n,
    input wire [127:0] data_in,
    input wire [127:0] key_in,
    output reg [127:0] data_out
);
    // Simple AES round transformation
    wire [127:0] add_round_key;
    
    // AddRoundKey operation
    assign add_round_key = data_in ^ key_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 128'd0;
        end else begin
            // For simplicity, just pass the result of AddRoundKey
            data_out <= add_round_key;
        end
    end
endmodule