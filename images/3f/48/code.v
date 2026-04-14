module simple_hash(
    input [4:0] in_data,
    output [2:0] out_hash
);
    assign out_hash = (in_data * 3) % 8;
endmodule