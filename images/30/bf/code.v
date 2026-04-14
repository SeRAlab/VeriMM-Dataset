module mac_address_checker(
    input [47:0] mac_address,
    output reg valid
);
    // Predefined MAC address
    localparam [47:0] PREDEFINED_MAC = 48'h001A2B3C4D5E;

    always @(*) begin
        if (mac_address == PREDEFINED_MAC) begin
            valid = 1'b1; // MAC address is valid
        end else begin
            valid = 1'b0; // MAC address is invalid
        end
    end
endmodule