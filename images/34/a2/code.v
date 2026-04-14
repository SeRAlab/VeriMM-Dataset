module hash_table (
    input [3:0] key,
    output [2:0] index
);
    assign index = key % 8; // Simple hash function using modulo
endmodule