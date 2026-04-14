module sliding_window_protocol #(parameter N = 4) (
    input clk,
    input rst,
    input send_packet,
    input ack,
    output reg [N-1:0] sent_packets,
    output reg [N-1:0] ack_packets
);
    reg [N-1:0] window;
    reg [2:0] state; // 0: idle, 1: sending, 2: waiting for ack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            sent_packets <= 0;
            ack_packets <= 0;
            window <= 0;
        end else begin
            case (state)
                0: begin // idle state
                    if (send_packet && (sent_packets < N)) begin
                        window <= (1 << sent_packets);
                        sent_packets <= sent_packets + 1;
                        state <= 1;
                    end
                end
                1: begin // sending state
                    state <= 2; // move to waiting for ack
                end
                2: begin // waiting for ack
                    if (ack) begin
                        ack_packets <= ack_packets | window;
                        window <= 0;
                        state <= 0; // return to idle
                    end
                end
            endcase
        end
    end
endmodule