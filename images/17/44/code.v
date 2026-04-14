module sha256_simple (
    input wire clk,
    input wire reset,
    input wire [511:0] message_in,
    output reg [255:0] hash_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hash_out <= 256'b0;
        end else begin
            hash_out <= message_in[255:0]; // Simple truncation for demonstration
        end
    end
endmodule