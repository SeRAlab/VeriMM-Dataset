module packet_filter (
    input [31:0] src_ip,
    input [255:0] allowed_ips,
    output reg allow
);
    integer i;
    always @(*) begin
        allow = 0; // Default deny
        for (i = 0; i < 8; i = i + 1) begin
            if (allowed_ips[i*32 +: 32] == src_ip) begin
                allow = 1; // Allow if found
            end
        end
    end
endmodule