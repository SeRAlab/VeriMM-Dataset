module hmac(
    input wire clk,
    input wire rst,
    input wire [7:0] key,
    input wire [7:0] message,
    output reg [7:0] hmac_out
);
    reg [7:0] key_reg;
    reg [7:0] message_reg;
    reg [7:0] hash_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            key_reg <= 8'b0;
            message_reg <= 8'b0;
            hash_reg <= 8'b0;
            hmac_out <= 8'b0;
        end else begin
            key_reg <= key;
            message_reg <= message;
            hash_reg <= key_reg ^ message_reg; // Simple hash function using XOR
            hmac_out <= hash_reg; // Output the computed HMAC
        end
    end
endmodule