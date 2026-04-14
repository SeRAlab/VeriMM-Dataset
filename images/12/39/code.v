module sliding_window_protocol(
    input clk,
    input rst,
    input send,
    input ack,
    output reg [3:0] sent_packets,
    output reg [3:0] acknowledged_packets,
    output reg [3:0] window_size
);
    parameter WINDOW_SIZE = 4;
    initial begin
        sent_packets = 0;
        acknowledged_packets = 0;
        window_size = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sent_packets <= 0;
            acknowledged_packets <= 0;
            window_size <= 0;
        end else begin
            if (send && (sent_packets - acknowledged_packets < WINDOW_SIZE)) begin
                sent_packets <= sent_packets + 1;
                window_size <= window_size + 1;
            end
            if (ack && (acknowledged_packets < sent_packets)) begin
                acknowledged_packets <= acknowledged_packets + 1;
                window_size <= window_size - 1;
            end
        end
    end
endmodule