module NAT (
    input [31:0] internal_ip,
    input [31:0] external_ip,
    input operation_code, // 0 for mapping, 1 for unmapping
    output reg [31:0] translated_ip
);
    always @(*) begin
        if (operation_code == 0) begin
            // Mapping: internal IP to external IP
            translated_ip = external_ip;
        end
        else begin
            // Unmapping: external IP to internal IP
            translated_ip = internal_ip;
        end
    end
endmodule