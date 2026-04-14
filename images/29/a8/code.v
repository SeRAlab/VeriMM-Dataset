module sha256 (
    input wire clk,
    input wire rst,
    input wire [255:0] data_in,
    input wire valid,
    output reg [255:0] hash_out
);
    reg [255:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 256'h6a09e667bb67ae8584caa73b2c9e42c7958b5a308d313198a2e03707344a409;
            hash_out <= 256'h0;
        end else if (valid) begin
            state <= state + data_in; // Simplistic hash update just for demonstration
            hash_out <= state; // Output the current state as the hash
        end
    end
endmodule