module sha256_simple (
    input wire clk,
    input wire rst,
    input wire [255:0] data_in,
    output reg [7:0] hash_out
);
    reg [255:0] hash; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash <= 256'b0;
            hash_out <= 8'b0;
        end else begin
            // A simple hashing mechanism (not actual SHA-256)
            hash <= data_in ^ {hash[255:8], hash[7:0]}; // simple operation
            hash_out <= hash[7:0]; // output the first 8 bits
        end
    end
endmodule