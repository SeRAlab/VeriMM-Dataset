module simple_md5_hash (
    input wire clk,
    input wire rst,
    input wire [31:0] data_in,
    output reg [31:0] hash_out
);
    reg [31:0] temp_hash;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp_hash <= 32'h0;
            hash_out <= 32'h0;
        end else begin
            temp_hash <= (temp_hash + data_in) ^ (temp_hash << 5);
            hash_out <= temp_hash;
        end
    end
endmodule