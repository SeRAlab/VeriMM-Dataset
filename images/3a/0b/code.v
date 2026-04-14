module sliding_window_controller (
    input clk,
    input rst,
    input send,
    input ack,
    input [3:0] window_size, // 4-bit window size input
    output reg [3:0] sent_count, // number of packets sent
    output reg [3:0] ack_count  // number of packets acknowledged
);
    reg [3:0] window_start; // start of the window

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sent_count <= 0;
            ack_count <= 0;
            window_start <= 0;
        end else begin
            if (send && (sent_count - ack_count < window_size)) begin
                sent_count <= sent_count + 1;
            end
            
            if (ack) begin
                ack_count <= ack_count + 1;
            end
        end
    end
endmodule