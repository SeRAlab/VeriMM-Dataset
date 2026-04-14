module hmac(
    input [127:0] key,
    input [127:0] message,
    output reg [127:0] hmac_out,
    input clk,
    input reset
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hmac_out <= 128'b0;
        end else begin
            hmac_out <= key ^ message; // Simple XOR hash for demonstration
        end
    end
endmodule