module MMU (
    input clk,
    input [9:0] virtual_address,
    output reg [7:0] physical_address
);
    reg [7:0] lookup_table [0:1023]; // 1024 entries for 10-bit virtual addresses

    initial begin
        // Initialize lookup table with some values for testing
        lookup_table[0] = 8'h00;
        lookup_table[1] = 8'h01;
        lookup_table[2] = 8'h02;
        // ... Initialize other entries as needed ...
        lookup_table[1023] = 8'hFF; // Example last entry
    end

    always @(posedge clk) begin
        physical_address <= lookup_table[virtual_address];
    end
endmodule