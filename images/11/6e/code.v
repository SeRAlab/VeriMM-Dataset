module hash_table (
    input [4:0] key,
    output reg [2:0] hash
);
    always @(*) begin
        hash = key % 8;
    end
endmodule