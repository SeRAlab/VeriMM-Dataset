module sha256 (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [511:0] message,
    output reg [255:0] hash,
    output reg valid
);
    // Internal states and variables for the SHA-256 computation
    // ... (Implementation specifics, such as state variables, constants, etc.)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash <= 256'b0;
            valid <= 0;
            // Reset other internal states
        end else if (start) begin
            // Perform SHA-256 hashing algorithm
            // This is a placeholder for the actual computation logic
            hash <= message[255:0]; // Simple placeholder logic
            valid <= 1; // Indicate that output is valid
        end
    end
endmodule