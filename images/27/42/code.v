module hash_table (
    input [4:0] key,
    output [2:0] index
);
    assign index = key % 8;
endmodule