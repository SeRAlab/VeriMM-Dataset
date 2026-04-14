module hmac(
    input wire [127:0] key,
    input wire [127:0] message,
    output reg [127:0] hmac_out,
    input wire clk,
    input wire rst
);
    
    reg [127:0] inner_hash;
    reg [127:0] outer_hash;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hmac_out <= 128'b0;
            inner_hash <= 128'b0;
            outer_hash <= 128'b0;
        end else begin
            // Simple inner hash calculation (XOR key with message)
            inner_hash <= key ^ message;
            // Simple outer hash calculation (XOR key with inner_hash)
            outer_hash <= key ^ inner_hash;
            // Final HMAC output
            hmac_out <= outer_hash;
        end
    end
endmodule