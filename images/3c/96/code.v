module NAT(
    input [31:0] internal_ip,
    input [15:0] internal_port,
    input [31:0] external_ip,
    output reg [15:0] external_port
);
    always @* begin
        // Simple NAT: use the external port as internal port + 1
        external_port = internal_port + 1;
    end
endmodule