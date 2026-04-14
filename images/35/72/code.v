module sha256_compression(
    input wire clk,
    input wire rst,
    input wire [511:0] message,
    input wire [255:0] state_in,
    output reg [255:0] state_out
);
    reg [255:0] a, b, c, d, e, f, g, h;
    reg [511:0] k; // Constants for SHA-256
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_out <= 256'b0;
        end else begin
            // Initialize the state variables
            {a, b, c, d, e, f, g, h} <= state_in;

            // SHA-256 compression function algorithm
            for (i = 0; i < 64; i = i + 1) begin
                // Considering k[i] is predefined as SHA-256 constants
                // For simplicity, assume we have a pre-defined set of k
                // Perform the compression function operations (simplified)
                // Update the state variables according to SHA-256 algorithm
                
                // Example operations (not the full logic):
                h <= h + ((e & f) ^ (~e & g)) + k[i] + message[i*8 +: 8];
                d <= d + h;
                h <= h + ((a >> 2) ^ (a >> 13) ^ (a >> 22)) + ((b & c) | (d & (b | c)));
                a <= a + ((e >> 6) ^ (e >> 11) ^ (e >> 25));
                
                // Rotate left and update state variables
            end
            
            state_out <= {a, b, c, d, e, f, g, h}; // Output the new state
        end
    end
endmodule