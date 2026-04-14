module sliding_window_protocol (
    input clk,
    input reset,
    input [1:0] packet_in, // Packet number to send
    input ack,             // Acknowledgment from receiver
    output reg [1:0] packet_out, // Packet sent
    output reg [1:0] sent_count,  // Count of sent packets
    output reg full_window        // Indicates if the window is full
);
    parameter WINDOW_SIZE = 4; // Size of the sliding window

    // State to keep track of the number of sent packets
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sent_count <= 2'b00;
            packet_out <= 2'b00;
            full_window <= 1'b0;
        end else begin
            if (ack) begin
                // When acknowledgment is received, slide the window
                sent_count <= sent_count - 1'b1;
                full_window <= 1'b0;
            end
            
            if (!full_window && (sent_count < WINDOW_SIZE)) begin
                packet_out <= packet_in; // Send packet
                sent_count <= sent_count + 1'b1;
                if (sent_count == WINDOW_SIZE - 1) begin
                    full_window <= 1'b1; // Window is now full
                end
            end
        end
    end
endmodule