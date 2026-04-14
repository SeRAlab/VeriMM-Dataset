module hash_table (
    input [4:0] key,
    input insert,
    input lookup,
    output reg found
);
    reg [1:0] hash_table [0:7]; // Simple hash table array
    
    integer i;
    
    always @(*) begin
        found = 0; // Default output
        if (insert) begin
            // Insert the key into the hash table
            hash_table[key % 8] = 1; // Mark as present
        end
        if (lookup) begin
            // Check if the key is present in the hash table
            if (hash_table[key % 8] == 1) begin
                found = 1; // Key found
            end
        end
    end
endmodule