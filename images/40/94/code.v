module NAT (
    input wire [31:0] internal_ip,
    input wire [31:0] external_ip,
    input wire control,
    output reg [31:0] translated_ip
);

always @(control or internal_ip or external_ip) begin
    if (control) begin
        translated_ip = external_ip; // Translate to external IP
    end else begin
        translated_ip = internal_ip; // Keep internal IP
    end
end

endmodule