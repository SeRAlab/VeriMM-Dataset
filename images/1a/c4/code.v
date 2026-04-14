module mmu (
    input [31:0] virtual_address,
    output reg [31:0] physical_address
);

parameter OFFSET = 32'h20000000; // Offset for upper half of address space

always @(virtual_address) begin
    if (virtual_address < 32'h80000000) // Lower half
        physical_address = virtual_address; // Directly mapped
    else // Upper half
        physical_address = virtual_address + OFFSET; // Offset applied
end

endmodule