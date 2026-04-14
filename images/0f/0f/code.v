module sliding_window_protocol (
    input clk,
    input rst,
    input send_packet,
    input ack_received,
    output reg [1:0] window_start,
    output reg [1:0] window_end,
    output reg [3:0] sent_packets
);
    reg [1:0] state; // State: 0 - idle, 1 - sending, 2 - waiting for ack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            window_start <= 0;
            window_end <= 0;
            sent_packets <= 0;
        end else begin
            case (state)
                0: begin
                    if (send_packet && (window_end - window_start < 4)) begin
                        sent_packets <= sent_packets + 1;
                        window_end <= window_end + 1;
                        state <= 1; // Move to sending state
                    end
                end
                1: begin
                    if (ack_received) begin
                        window_start <= window_start + 1;
                        state <= 2; // Move to waiting for ack state
                    end
                end
                2: begin
                    if (!ack_received) begin
                        state <= 0; // Go back to idle state
                    end
                end
            endcase
        end
    end
endmodule