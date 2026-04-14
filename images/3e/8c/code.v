module pcie_decoder (
    input [3:0] address,
    output reg [3:0] enable
);

always @(*) begin
    enable = 4'b0000; // Default all enables to low
    if (address < 4'b0100) begin
        enable[address] = 1'b1; // Enable the device corresponding to the address
    end
end

endmodule