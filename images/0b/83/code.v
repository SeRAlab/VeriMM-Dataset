module HMAC (
    input [127:0] key,
    input [127:0] message,
    output reg [127:0] hmac
);
    always @(*) begin
        hmac = key ^ message; // Simple XOR-based HMAC for demonstration
    end
endmodule