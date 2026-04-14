module nat (
    input [31:0] internal_ip,
    output reg [31:0] external_ip
);
    always @(*) begin
        case (internal_ip)
            32'hC0A80001: external_ip = 32'h1A2B3C4D; // 192.168.0.1 to 26.43.60.77
            32'hC0A80002: external_ip = 32'h1A2B3C4E; // 192.168.0.2 to 26.43.60.78
            32'hC0A80003: external_ip = 32'h1A2B3C4F; // 192.168.0.3 to 26.43.60.79
            32'hC0A80004: external_ip = 32'h1A2B3C50; // 192.168.0.4 to 26.43.60.80
            32'hC0A80005: external_ip = 32'h1A2B3C51; // 192.168.0.5 to 26.43.60.81
            default: external_ip = 32'h00000000; // No match
        endcase
    end
endmodule