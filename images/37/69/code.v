module hash_table(
    input [4:0] key,
    output [2:0] hash_index
);
    assign hash_index = key % 8; // Simple hash function using modulo
endmodule