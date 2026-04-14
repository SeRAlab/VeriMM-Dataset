module md5_hash (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [3:0] hash_out
);

    parameter CONSTANT = 4'b1010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hash_out <= 4'b0000;
        end else begin
            hash_out <= data_in ^ CONSTANT;
        end
    end

endmodule