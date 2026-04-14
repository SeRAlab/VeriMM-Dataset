module packet_filter(
    input clk,
    input rst,
    input [15:0] dst_port,
    input enable,
    output reg accepted
);
    parameter PORT_TO_ALLOW = 16'h0050; // Port 80 in hexadecimal
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accepted <= 0;
        end else if (enable) begin
            if (dst_port == PORT_TO_ALLOW) begin
                accepted <= 1; // Packet accepted
            end else begin
                accepted <= 0; // Packet dropped
            end
        end
    end
endmodule