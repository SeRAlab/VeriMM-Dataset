module checksum_calculator (
    input [4:0] data_in,
    output [5:0] data_out
);
    wire checksum;
    
    assign checksum = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4];
    assign data_out = {data_in, checksum};
endmodule