module mac_address_filter(
    input [47:0] mac_address,
    output reg is_allowed
);
    always @(*) begin
        if (mac_address == 48'hAABBCCDDEEFF) 
            is_allowed = 1'b1;
        else 
            is_allowed = 1'b0;
    end
endmodule