module packet_filter (
    input wire clk,
    input wire rst,
    input wire [31:0] packet,
    input wire filter_enable,
    output reg packet_accepted
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            packet_accepted <= 0;
        end else if (filter_enable) begin
            if (packet[31:24] == 8'hAB) begin
                packet_accepted <= 1; // Accept packet
            end else begin
                packet_accepted <= 0; // Drop packet
            end
        end
    end
endmodule