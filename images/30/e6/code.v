module hmac (
    input wire [7:0] key,
    input wire [7:0] message,
    input wire clk,
    input wire rst,
    output reg [7:0] hash
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash <= 8'b0;
        end else begin
            hash <= key ^ message;  // Simple XOR for HMAC
        end
    end
endmodule