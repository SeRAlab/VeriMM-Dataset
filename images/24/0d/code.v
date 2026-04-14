module nat_translation(
    input [31:0] internal_ip,
    output reg [31:0] external_ip
);
    always @(*) begin
        case (internal_ip)
            32'hC0A80101: external_ip = 32'hCB00711; // 192.168.1.1 -> 203.0.113.1
            32'hC0A80102: external_ip = 32'hCB00712; // 192.168.1.2 -> 203.0.113.2
            32'hC0A80103: external_ip = 32'hCB00713; // 192.168.1.3 -> 203.0.113.3
            default: external_ip = 32'h0; // Not found
        endcase
    end
endmodule