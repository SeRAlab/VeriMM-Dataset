module hmac(
    input wire clk,
    input wire [7:0] key,
    input wire [7:0] message,
    output reg [7:0] mac
);
    always @(posedge clk) begin
        mac <= key ^ message; // Simple XOR for demonstration
    end
endmodule