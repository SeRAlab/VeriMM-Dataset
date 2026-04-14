module mac_address_filter (
    input [47:0] received_mac,
    input [47:0] allowed_mac_1,
    input [47:0] allowed_mac_2,
    input [47:0] allowed_mac_3,
    output reg is_valid
);
    always @(*) begin
        if (received_mac == allowed_mac_1 || 
            received_mac == allowed_mac_2 || 
            received_mac == allowed_mac_3) 
        begin
            is_valid = 1'b1; // Address is valid
        end else begin
            is_valid = 1'b0; // Address is invalid
        end
    end
endmodule