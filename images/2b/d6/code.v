module hmac (
    input clk,
    input reset,
    input [7:0] key,
    input [7:0] message,
    output reg [7:0] hmac_out
);
    reg [7:0] k_xor_m;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hmac_out <= 8'b0;
        end else begin
            // Simple HMAC computation: HMAC = key XOR message
            k_xor_m <= key ^ message;
            hmac_out <= k_xor_m;  // Output the HMAC
        end
    end
endmodule