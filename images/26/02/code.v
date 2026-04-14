module sliding_window_controller (
    input wire clk,
    input wire rst,
    input wire send_packet,
    input wire ack_received,
    output reg [3:0] current_window_size,
    output reg [3:0] next_seq_num,
    output reg [3:0] ack_num
);

    parameter MAX_WINDOW_SIZE = 4'd4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_window_size <= 4'd0;
            next_seq_num <= 4'd0;
            ack_num <= 4'd0;
        end else begin
            if (send_packet && current_window_size < MAX_WINDOW_SIZE) begin
                current_window_size <= current_window_size + 1;
                next_seq_num <= next_seq_num + 1;
            end
            if (ack_received && ack_num < next_seq_num) begin
                ack_num <= ack_num + 1;
                current_window_size <= current_window_size - 1;
            end
        end
    end
endmodule