module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire frame_start,
    input wire [7:0] frame_data,
    input wire valid,
    output reg [7:0] processed_frame,
    output reg ready
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            processed_frame <= 8'b0;
            ready <= 1'b1;
        end else if (frame_start && valid) begin
            processed_frame <= frame_data; // Simulating frame processing
            ready <= 1'b0; // Not ready until processed
        end else if (!frame_start) begin
            ready <= 1'b1; // Ready for new frame
        end
    end
endmodule