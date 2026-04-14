module simple_hash_table (
    input wire [4:0] key,
    input wire [7:0] value,
    input wire insert,
    input wire retrieve,
    output reg [7:0] out_value,
    output reg found
);
    // Define the size of the hash table
    reg [7:0] hash_table [0:31]; // 32 entries for keys 0-31
    reg [1:0] valid [0:31]; // Valid flag for each entry

    always @(*) begin
        found = 0;
        out_value = 8'b0;

        if (insert) begin
            hash_table[key] = value;
            valid[key] = 2'b11; // Mark as valid
        end

        if (retrieve && valid[key] == 2'b11) begin
            out_value = hash_table[key];
            found = 1;
        end
    end
endmodule