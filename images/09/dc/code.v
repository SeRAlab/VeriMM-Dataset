module sliding_window_protocol (
    input clk,
    input reset,
    input send_pkt,
    input ack_received,
    output reg [3:0] sent_count,
    output reg [3:0] ack_count,
    output reg window_full
);
    parameter WINDOW_SIZE = 4;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sent_count <= 0;
            ack_count <= 0;
            window_full <= 0;
        end else begin
            if (send_pkt && sent_count < WINDOW_SIZE) begin
                sent_count <= sent_count + 1;
            end
            if (ack_received && ack_count < sent_count) begin
                ack_count <= ack_count + 1;
            end
            if (sent_count >= WINDOW_SIZE) begin
                window_full <= 1;
            end else begin
                window_full <= 0;
            end
        end
    end
endmodule