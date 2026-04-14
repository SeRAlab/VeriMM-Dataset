module sliding_window_receiver (
    input wire clk,
    input wire reset,
    input wire [7:0] incoming_packet,
    input wire packet_valid,
    output reg ack,
    output reg [1:0] window_status // Status of the window
);
    parameter WINDOW_SIZE = 4; // Define window size (1 to 4)
    reg [1:0] received_count; // Counter for received packets

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            received_count <= 0;
            window_status <= 0;
            ack <= 0;
        end else begin
            if (packet_valid && (received_count < WINDOW_SIZE)) begin
                received_count <= received_count + 1;
                ack <= 1; // Acknowledge the packet
            end else begin
                ack <= 0; // No acknowledgment
            end
            window_status <= received_count; // Update window status
        end
    end
endmodule