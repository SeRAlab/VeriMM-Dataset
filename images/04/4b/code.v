module md5_hash(
    input clk,
    input rst,
    input valid,
    input [511:0] message,
    output reg [127:0] hash
);
    reg [127:0] hash_value;
    reg [63:0] chunk;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash_value <= 128'hd41d8cd98f00b204e9800998ecf8427e; // Initial MD5 constant
        end else if (valid) begin
            for (i = 0; i < 8; i = i + 1) begin
                chunk <= message[511 - (i * 64) -: 64];
                // Simplified hash operation (not actual MD5 for the sake of the example)
                hash_value <= hash_value ^ chunk;
            end
            hash <= hash_value;
        end
    end
endmodule