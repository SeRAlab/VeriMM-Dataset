module sliding_window_protocol #(parameter WINDOW_SIZE = 4, parameter DATA_WIDTH = 8) (
    input clk,
    input reset,
    input [DATA_WIDTH-1:0] data_in,
    input send_enable,
    input ack,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg send_ready,
    output reg [3:0] window_position
);
    reg [3:0] next_window_position;
    reg [3:0] sent_packets;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window_position <= 0;
            sent_packets <= 0;
            send_ready <= 1;
            data_out <= 0;
        end else begin
            if (send_enable && send_ready && (sent_packets < WINDOW_SIZE)) begin
                data_out <= data_in;
                sent_packets <= sent_packets + 1;
                send_ready <= (sent_packets + 1 < WINDOW_SIZE);
            end
            
            if (ack) begin
                sent_packets <= sent_packets - 1;
                send_ready <= 1; // Ready to send again
            end
            
            window_position <= sent_packets;
        end
    end
endmodule