module packet_filter(
    input [15:0] packet,
    input [3:0] protocol,
    input enable,
    output reg allowed
);

always @(*) begin
    if (!enable) begin
        allowed = 0; // Block if not enabled
    end else if (protocol == 4'b0001 || protocol == 4'b0010 || protocol == 4'b0011) begin
        allowed = 1; // Allow specific protocols
    end else begin
        allowed = 0; // Block all others
    end
end

endmodule