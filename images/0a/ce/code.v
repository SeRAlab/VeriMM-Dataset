module sliding_window_protocol(
    input wire clk,
    input wire reset,
    input wire send_frame,
    input wire ack_received,
    output reg [3:0] sent_count,
    output reg [3:0] ack_count,
    output reg window_full,
    output reg ready_to_send
);

    parameter WINDOW_SIZE = 4;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sent_count <= 0;
            ack_count <= 0;
            window_full <= 0;
            ready_to_send <= 1;
        end else begin
            if (send_frame && !window_full && ready_to_send) begin
                sent_count <= sent_count + 1;
                if (sent_count == WINDOW_SIZE - 1) begin
                    window_full <= 1;
                    ready_to_send <= 0;
                end
            end
            
            if (ack_received) begin
                ack_count <= ack_count + 1;
                if (ack_count < sent_count) begin
                    ready_to_send <= 1;
                    if (window_full && ack_count == sent_count - 1) begin
                        window_full <= 0;
                    end
                end
            end
        end
    end
endmodule