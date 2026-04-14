module ethernet_mac_controller(
    input clk,
    input reset,
    input [47:0] mac_address,
    input [7:0] data_in,
    input data_valid,
    output reg frame_sent,
    output reg frame_received,
    output reg [7:0] data_out
);
    reg [7:0] frame_buffer [0:15]; // Buffer for frames
    reg [3:0] frame_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frame_sent <= 0;
            frame_received <= 0;
            frame_count <= 0;
        end else begin
            if (data_valid && frame_count < 16) begin
                frame_buffer[frame_count] <= data_in; // Store incoming data
                frame_count <= frame_count + 1;
            end
            
            if (frame_count > 0) begin
                frame_sent <= 1; // Frame is sent
                frame_received <= 0; // Reset received flag
                // Simulate sending the frame
                frame_count <= 0; // Reset count after sending
            end else begin
                frame_sent <= 0;
            end
        end
    end
endmodule