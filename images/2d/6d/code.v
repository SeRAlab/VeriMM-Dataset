module pcie_address_decoder (
    input [31:0] address,
    output reg [3:0] chip_select
);
    always @(*) begin
        chip_select = address[3:0]; // Extract the lower 4 bits for chip select
    end
endmodule