module pcie_device_enable (
    input [4:0] device_id,
    output reg device_enable
);

always @(*) begin
    case (device_id)
        5'b00001: device_enable = 1'b1; // Device ID 1 is enabled
        5'b00010: device_enable = 1'b1; // Device ID 2 is enabled
        5'b00011: device_enable = 1'b1; // Device ID 3 is enabled
        default: device_enable = 1'b0;   // All other IDs are disabled
    endcase
end

endmodule