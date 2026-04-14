module nat_translation (
    input wire clk,
    input wire reset,
    input wire [31:0] private_ip,
    input wire request,
    output reg [31:0] public_ip
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            public_ip <= 32'b0;
        end else if (request) begin
            case (private_ip)
                32'hC0A80001: public_ip <= 32'h1A2B3C4D; // 192.168.0.1 -> 26.43.60.77
                32'hC0A80002: public_ip <= 32'h1A2B3C4E; // 192.168.0.2 -> 26.43.60.78
                32'hC0A80003: public_ip <= 32'h1A2B3C4F; // 192.168.0.3 -> 26.43.60.79
                32'hC0A80004: public_ip <= 32'h1A2B3C50; // 192.168.0.4 -> 26.43.60.80
                default: public_ip <= 32'hFFFFFFFF; // Unknown
            endcase
        end
    end
endmodule