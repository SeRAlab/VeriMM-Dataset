module hash_table (
    input [4:0] data_in,
    output [2:0] hash_out
);
    parameter TABLE_SIZE = 8;

    assign hash_out = data_in % TABLE_SIZE;

endmodule