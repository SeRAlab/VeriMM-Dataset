module sliding_window_protocol (
    input clk,
    input reset,
    input send_packet,
    input ack_received,
    output reg [1:0] window_position,
    output reg sending
);
    reg [1:0] window_size;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window_position <= 0;
            sending <= 0;
            window_size <= 3;  // Fixed window size of 3
        end else begin
            if (send_packet && window_position < window_size) begin
                sending <= 1;
                window_position <= window_position + 1;
            end
            if (ack_received) begin
                sending <= 0;
                if (window_position > 0) begin
                    window_position <= window_position - 1;
                end
            end
        end
    end
endmodule