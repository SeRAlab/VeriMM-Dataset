module pcie_address_decoder (
    input [4:0] address,
    output reg valid
);
    always @(*) begin
        if (address >= 5'b11010 && address <= 5'b11111) // 0x1A to 0x1F
            valid = 1;
        else
            valid = 0;
    end
endmodule