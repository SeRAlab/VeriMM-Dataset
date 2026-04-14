module nat (
    input clk,
    input rst_n,
    input [31:0] internal_ip,
    input req,
    output reg [31:0] external_ip,
    output reg valid
);
    parameter EXTERNAL_IP = 32'hC0A80101; // 192.168.1.1
    parameter INTERNAL_IP_START = 32'h0A000000; // 10.0.0.0
    parameter INTERNAL_IP_END = 32'h0AFFFFFF; // 10.255.255.255

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            external_ip <= 32'b0;
            valid <= 0;
        end else begin
            if (req) begin
                if (internal_ip >= INTERNAL_IP_START && internal_ip <= INTERNAL_IP_END) begin
                    external_ip <= EXTERNAL_IP;
                    valid <= 1;
                end else begin
                    valid <= 0;
                end
            end
        end
    end
endmodule