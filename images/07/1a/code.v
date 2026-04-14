module sliding_window_protocol (
    input clk,
    input reset,
    input send,        // Signal to send data frame
    input ack,         // Acknowledgment signal from receiver
    output reg [3:0] sender_window, // Sender's current window size
    output reg [3:0] receiver_window  // Receiver's current window size
);

parameter MAX_WINDOW_SIZE = 4;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sender_window <= 0;
        receiver_window <= 0;
    end else begin
        // Sending frame logic
        if (send && (sender_window < MAX_WINDOW_SIZE)) begin
            sender_window <= sender_window + 1;
        end
        
        // Acknowledgment logic
        if (ack && (receiver_window < MAX_WINDOW_SIZE)) begin
            receiver_window <= receiver_window + 1;
            sender_window <= sender_window - 1; // Reduce sender window on ack
        end
    end
end

endmodule