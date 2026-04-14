module mac_address_filter (
    input  [47:0] mac_address,
    input  [47:0] filter_address,
    output match
);
    assign match = (mac_address == filter_address);
endmodule