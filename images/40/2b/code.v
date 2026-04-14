module hash_table (
    input [4:0] key,
    output reg [2:0] index
);

always @(*) begin
    index = key % 8;
end

endmodule