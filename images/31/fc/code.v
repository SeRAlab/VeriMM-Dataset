module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire data_valid,
    output reg frame_received
);
    reg [7:0] frame_buffer [0:15]; // Buffer for incoming frame
    reg [3:0] byte_count; // Count of bytes received

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frame_received <= 0;
            byte_count <= 0;
        end else if (data_valid) begin
            if (byte_count < 16) begin
                frame_buffer[byte_count] <= data_in; // Store incoming data
                byte_count <= byte_count + 1; // Increment byte count
            end
            if (byte_count == 15) begin
                frame_received <= 1; // Indicate frame received
            end
        end
    end
endmodule