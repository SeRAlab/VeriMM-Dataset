module sliding_window_protocol #(parameter WINDOW_SIZE = 4, SEQ_NUM_WIDTH = 3) (
    input clk,
    input reset,
    input send_packet,
    input ack_received,
    output reg [SEQ_NUM_WIDTH-1:0] sent_seq_num,
    output reg [SEQ_NUM_WIDTH-1:0] ack_seq_num,
    output reg window_full
);

    reg [SEQ_NUM_WIDTH-1:0] next_sent_seq_num;
    reg [SEQ_NUM_WIDTH-1:0] next_ack_seq_num;
    reg [SEQ_NUM_WIDTH-1:0] send_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sent_seq_num <= 0;
            ack_seq_num <= 0;
            send_count <= 0;
            window_full <= 0;
        end else begin
            if (send_packet && !window_full) begin
                sent_seq_num <= next_sent_seq_num;
                send_count <= send_count + 1;
                if (send_count == WINDOW_SIZE - 1) begin
                    window_full <= 1;
                end
            end
            
            if (ack_received) begin
                ack_seq_num <= ack_seq_num + 1;
                if (send_count > 0) begin
                    send_count <= send_count - 1;
                end
                if (send_count < WINDOW_SIZE) begin
                    window_full <= 0;
                end
            end
        end
    end

    always @(*) begin
        next_sent_seq_num = sent_seq_num + 1;
        next_ack_seq_num = ack_seq_num;
    end
endmodule