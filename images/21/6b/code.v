module packet_filter (
    input [31:0] src_ip,
    input enable,
    output reg allow
);
    parameter TARGET_IP = 32'hC0A80101; // 192.168.1.1 in hexadecimal

    always @(*) begin
        if (enable) begin
            if (src_ip == TARGET_IP)
                allow = 1'b1; // Allow
            else
                allow = 1'b0; // Deny
        end else begin
            allow = 1'b0; // Deny when enable is low
        end
    end
endmodule