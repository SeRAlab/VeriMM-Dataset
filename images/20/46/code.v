module md5_simple (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    input wire data_valid,
    output reg [31:0] hash_out,
    output reg ready
);
    reg [31:0] state;
    reg [31:0] temp_hash;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            hash_out <= 0;
            ready <= 0;
        end else begin
            case (state)
                0: begin
                    if (data_valid) begin
                        temp_hash <= data_in ^ 32'h5A5A5A5A; // Initial XOR with a magic number
                        state <= 1; // Move to processing state
                    end
                end
                1: begin
                    // Simple rotation and XOR to generate a hash
                    temp_hash <= {temp_hash[15:0], temp_hash[31:16]} ^ (temp_hash + 32'hA3A3A3A3);
                    hash_out <= temp_hash;
                    ready <= 1; // Indicate that the hash is ready
                    state <= 0; // Return to idle state
                end
            endcase
        end
    end
endmodule