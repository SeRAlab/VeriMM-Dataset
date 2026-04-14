module ethernet_mac_controller (
    input wire clk,
    input wire rst,
    input wire [47:0] dest_addr,
    input wire [47:0] mac_addr,
    output reg frame_received
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        frame_received <= 0;
    end else begin
        if (dest_addr == mac_addr) begin
            frame_received <= 1; // Frame is received
        end else begin
            frame_received <= 0; // Frame is ignored
        end
    end
end

endmodule