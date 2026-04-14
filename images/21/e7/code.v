module md5_hash(
    input [31:0] data_in,
    input clk,
    input rst,
    output reg [31:0] hash_out
);

    reg [31:0] temp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash_out <= 32'h0;
            temp <= 32'h0;
        end else begin
            temp <= (data_in ^ hash_out) + 32'h5A827999;
            hash_out <= {temp[15:0], temp[31:16]};
        end
    end
endmodule