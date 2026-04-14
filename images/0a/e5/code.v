module hmac (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [63:0] key,
    input wire [63:0] message,
    output reg [63:0] hmac_out,
    output reg done
);

reg [63:0] hash;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        hmac_out <= 64'b0;
        done <= 0;
        hash <= 64'b0;
    end else if (enable) begin
        // Simple hash function: XOR the key and message
        hash <= key ^ message;
        hmac_out <= hash;
        done <= 1;
    end
end

endmodule