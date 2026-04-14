module simple_hash_table (
    input [4:0] key,
    output [2:0] hash
);
    assign hash = key % 8; // Simple hash function using modulus
endmodule