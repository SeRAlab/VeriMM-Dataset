module NAT (
    input wire clk,
    input wire enable,
    input wire [31:0] internal_ip,
    input wire [31:0] external_ip,
    output reg [31:0] translated_ip
);
    always @(posedge clk) begin
        if (enable) begin
            translated_ip <= external_ip; // Use external IP when enabled
        end
    end
endmodule