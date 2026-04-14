module sliding_window_protocol (
    input clk,
    input reset,
    input ack, // Acknowledgment signal from the receiver
    output reg [3:0] sent_packets, // Indicates which packets are sent
    output reg [3:0] next_to_send // Indicates the next packet to send
);
    reg [1:0] window_start; // Start of the sliding window
    reg [1:0] window_end;   // End of the sliding window (exclusive)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sent_packets <= 4'b0000;
            next_to_send <= 4'b0000;
            window_start <= 2'b00;
            window_end <= 2'b00;
        end else begin
            // Send new packets if within the window size
            if (window_end - window_start < 4) begin
                sent_packets[window_end] <= 1; // Send packet at window_end
                window_end <= window_end + 1;
            end
            
            // Slide the window when ACK is received
            if (ack && window_start < window_end) begin
                sent_packets[window_start] <= 0; // Packet acknowledged
                window_start <= window_start + 1;
            end
        end
    end
endmodule