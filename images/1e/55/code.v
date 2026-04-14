module packet_filter (
    input [4:0] source_ip,
    input [3:0] dest_port,
    input control_signal,
    output reg packet_allowed
);
    always @(*) begin
        // Simple filtering based on control signal
        if (control_signal) begin
            packet_allowed = 1'b1;  // Allow packet
        end else begin
            packet_allowed = 1'b0;  // Deny packet
        end
    end
endmodule