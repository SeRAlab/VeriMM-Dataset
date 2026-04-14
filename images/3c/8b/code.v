module sha256_step(
    input clk,
    input reset,
    input [511:0] message,
    output reg [255:0] hash
);
    reg [255:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 256'd0;
            hash <= 256'd0;
        end else begin
            // Simple example of SHA-256 step processing
            state <= state ^ message[255:0]; // Example operation
            hash <= state; // Update hash output
        end
    end
endmodule