module simple_des_encryption (
    input clk,
    input [7:0] data_in,
    input [2:0] key,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    data_out <= (data_in ^ {key[2], key[1], key[0], key[2], key[1], key[0], key[2], key[1]});
end

endmodule