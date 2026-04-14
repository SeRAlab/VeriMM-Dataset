module aes_encrypt (
    input [7:0] data_in,
    input [7:0] key,
    input clk,
    input rst,
    output reg [7:0] data_out
);
    reg [7:0] state;
    reg [7:0] round_key;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 8'b0;
            round_key <= key;
            data_out <= 8'b0;
        end else begin
            // XOR the input data with the round key as part of the AES process
            state <= data_in ^ round_key;
            // For simplicity, we will output the state directly as the encrypted data
            data_out <= state;
        end
    end
endmodule