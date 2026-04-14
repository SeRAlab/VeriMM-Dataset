module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire [15:0] frame_length, // in bytes
    output reg frame_valid // 1 if valid, 0 if invalid
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        frame_valid <= 0;
    end else begin
        if (frame_length >= 64 && frame_length <= 1518) begin
            frame_valid <= 1; // valid frame
        end else begin
            frame_valid <= 0; // invalid frame
        end
    end
end

endmodule