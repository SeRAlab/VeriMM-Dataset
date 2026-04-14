module packet_filter (
    input [31:0] src_ip,
    input [15:0] dest_port,
    input [7:0] protocol,
    output reg accept
);

always @(*) begin
    accept = 0; // Default to reject
    if ((src_ip == 32'hC0A80101) && (dest_port == 16'd80) && (protocol == 8'd6)) begin
        accept = 1; // Rule 1
    end else if ((src_ip == 32'h0A000005) && (dest_port == 16'd443)) begin
        accept = 1; // Rule 2
    end
end

endmodule