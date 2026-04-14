module ethernet_mac_controller (
    input clk,
    input rst,
    input [7:0] data_in,
    input frame_valid,
    output reg [7:0] data_out,
    output reg frame_ready
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
            frame_ready <= 1'b0;
        end else if (frame_valid) begin
            data_out <= data_in; // Pass-through logic
            frame_ready <= 1'b1; // Signal that the frame is ready
        end else begin
            frame_ready <= 1'b0; // Frame not ready if no valid input
        end
    end
endmodule