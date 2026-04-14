module hash_table (
    input [4:0] address,
    output [2:0] data
);
    assign data = (address[4:2] ^ address[1:0]);
endmodule