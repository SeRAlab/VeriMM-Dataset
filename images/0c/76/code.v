module mac_address_filter(
    input [47:0] mac_address,
    output reg allowed
);
    parameter ALLOWED_MAC = 48'h001A2B3C4D5E; // Allowed MAC address

    always @(*) begin
        if (mac_address == ALLOWED_MAC)
            allowed = 1'b1; // Allowed
        else
            allowed = 1'b0; // Not allowed
    end
endmodule