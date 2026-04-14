module packet_filter (
    input wire clk,
    input wire rst,
    input wire [7:0] src_ip,
    input wire [7:0] dest_ip,
    input wire [7:0] port,
    input wire rule_enable,
    output reg packet_allowed
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            packet_allowed <= 0;
        end else if (rule_enable) begin
            if (src_ip == 8'b10011000 && dest_ip == 8'b11010101 && port == 8'b00111000) begin
                packet_allowed <= 1; // Packet allowed
            end else begin
                packet_allowed <= 0; // Packet dropped
            end
        end
    end
endmodule