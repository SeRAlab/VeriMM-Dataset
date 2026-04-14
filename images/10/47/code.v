module sha256 (
    input clk,
    input rst,
    input start,
    input [511:0] message,
    output reg [255:0] hash,
    output reg done
);

    reg [511:0] message_reg;
    reg [255:0] hash_reg [0:63]; // Temporary storage for hash values
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash <= 256'b0;
            done <= 1'b0;
            message_reg <= 512'b0;
            for (i = 0; i < 64; i = i + 1) begin
                hash_reg[i] <= 256'b0;
            end
        end else if (start) begin
            message_reg <= message;
            // Simplified hash computation for demonstration
            // Placeholder for actual SHA-256 algorithm
            hash <= message_reg[255:0] ^ message_reg[511:256]; // Dummy operation
            done <= 1'b1;
        end
    end
endmodule