module bluetooth_address_checker (
    input [47:0] address, // 6-byte Bluetooth address
    output reg valid       // Output signal indicating validity
);

always @(*) begin
    // Check if address is all zeros
    if (address == 48'h000000000000) begin
        valid = 1'b0; // Invalid address
    end else begin
        valid = 1'b1; // Valid address
    end
end

endmodule