module simple_hash_table (
    input [4:0] addr,
    input [4:0] data_in,
    input write_en,
    output reg [4:0] data_out
);

    reg [4:0] hash_table [3:0]; // 4 entries of 5 bits each

    always @(*) begin
        if (write_en) begin
            hash_table[addr[3:2]] = data_in; // Write data to the hash table
        end
        data_out = hash_table[addr[3:2]]; // Read data from the hash table
    end
endmodule