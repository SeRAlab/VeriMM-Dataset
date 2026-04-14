module sliding_window_controller(
    input clk,
    input reset,
    input send_request,
    input ack,
    output reg [3:0] window_size,
    output reg [3:0] sent_count,
    output reg [3:0] ack_count,
    output reg can_send
);
    parameter MAX_WINDOW_SIZE = 4;
    
    initial begin
        window_size = MAX_WINDOW_SIZE;
        sent_count = 0;
        ack_count = 0;
        can_send = 1'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window_size <= MAX_WINDOW_SIZE;
            sent_count <= 0;
            ack_count <= 0;
            can_send <= 1'b0;
        end else begin
            if (send_request && window_size > 0) begin
                sent_count <= sent_count + 1;
                window_size <= window_size - 1;
                can_send <= 1'b1;
            end else begin
                can_send <= 1'b0;
            end

            if (ack) begin
                ack_count <= ack_count + 1;
                window_size <= window_size + 1;
            end
        end
    end
endmodule