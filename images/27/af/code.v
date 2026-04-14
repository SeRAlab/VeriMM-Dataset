module HMAC (
    input wire clk,
    input wire reset,
    input wire valid_in,
    input wire [127:0] key,
    input wire [127:0] message,
    output reg [127:0] hmac_output,
    output reg valid_out
);
    reg [127:0] inner_hash;
    reg [127:0] outer_hash;
    reg state; // 0 for initial, 1 for complete

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hmac_output <= 128'b0;
            valid_out <= 1'b0;
            state <= 1'b0;
        end else if (valid_in) begin
            // Simulate HMAC calculation using XOR
            inner_hash <= key ^ message;
            outer_hash <= key ^ inner_hash;
            hmac_output <= outer_hash;
            valid_out <= 1'b1;
            state <= 1'b1;
        end else if (state) begin
            valid_out <= 1'b0; // Reset valid_out after output
        end
    end
endmodule