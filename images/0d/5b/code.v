module packet_filter (
    input [4:0] src,
    input [4:0] dst,
    input [4:0] src_allowed,
    input [4:0] dst_allowed,
    output valid_packet
);
    assign valid_packet = (src == src_allowed) && (dst == dst_allowed);
endmodule