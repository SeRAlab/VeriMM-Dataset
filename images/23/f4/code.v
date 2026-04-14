module sliding_window_protocol (
    input clk,
    input reset,
    input send_packet,
    input ack_packet,
    output reg [3:0] window_start,
    output reg [3:0] window_end,
    output reg [3:0] packets_sent,
    output reg [3:0] packets_acknowledged
);
    parameter WINDOW_SIZE = 4;

    initial begin
        window_start = 0;
        window_end = WINDOW_SIZE - 1;
        packets_sent = 0;
        packets_acknowledged = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window_start <= 0;
            window_end <= WINDOW_SIZE - 1;
            packets_sent <= 0;
            packets_acknowledged <= 0;
        end else begin
            if (send_packet && packets_sent < WINDOW_SIZE) begin
                packets_sent <= packets_sent + 1;
            end

            if (ack_packet && packets_acknowledged < packets_sent) begin
                packets_acknowledged <= packets_acknowledged + 1;
            end
            
            if (packets_acknowledged == packets_sent) begin
                window_start <= window_start + 1;
                window_end <= window_start + WINDOW_SIZE - 1;
            end
        end
    end
endmodule