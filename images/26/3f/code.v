module hash_table (
    input [4:0] key,
    output reg [2:0] hash_value
);
    always @(*) begin
        if (key < 32) // Validating key to be within the 5-bit range
            hash_value = key % 8;
        else
            hash_value = 3'bxxx; // Invalid case
    end
endmodule