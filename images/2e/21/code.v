module sliding_window_protocol (
    input clk,
    input rst,
    input send_data,
    input ack_received,
    output reg [3:0] window_start,
    output reg [3:0] window_end,
    output reg [3:0] next_packet,
    output reg window_full,
    output reg window_empty
);

    parameter WINDOW_SIZE = 4;
    reg [3:0] current_packet;
    reg [3:0] num_packets_in_window;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            window_start <= 0;
            window_end <= 0;
            current_packet <= 0;
            num_packets_in_window <= 0;
            window_full <= 0;
            window_empty <= 1;
        end else begin
            if (send_data && !window_full) begin
                current_packet <= current_packet + 1;
                window_end <= (window_end + 1) % WINDOW_SIZE;
                num_packets_in_window <= num_packets_in_window + 1;
            end
            if (ack_received && num_packets_in_window > 0) begin
                window_start <= (window_start + 1) % WINDOW_SIZE;
                num_packets_in_window <= num_packets_in_window - 1;
            end
            window_full <= (num_packets_in_window == WINDOW_SIZE);
            window_empty <= (num_packets_in_window == 0);
            next_packet <= (window_start + num_packets_in_window) % WINDOW_SIZE;
        end
    end
endmodule