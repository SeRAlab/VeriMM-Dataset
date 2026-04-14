module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire [15:0] frame_length,
    input wire [47:0] dest_address,
    output reg frame_valid
);
    parameter VALID_DEST_ADDR = 48'hAABBCCDDEEFF; // Example valid address
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frame_valid <= 0;
        end else begin
            if ((frame_length >= 64 && frame_length <= 1518) && (dest_address == VALID_DEST_ADDR)) begin
                frame_valid <= 1;
            end else begin
                frame_valid <= 0;
            end
        end
    end
endmodule