module hmac_generator (
    input wire clk,
    input wire rst,
    input wire [127:0] key,      // Key input
    input wire [127:0] message,  // Message input
    output reg [127:0] hmac      // HMAC output
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hmac <= 128'b0; // Reset HMAC
        end else begin
            hmac <= key ^ message; // Simple HMAC generation
        end
    end
endmodule