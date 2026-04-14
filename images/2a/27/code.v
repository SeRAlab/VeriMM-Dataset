module sliding_window_controller (
    input clk,
    input rst,
    input send,
    input ack,
    output reg [3:0] current_window,
    output reg [3:0] packet_to_send,
    output reg window_valid
);

    parameter MAX_WINDOW_SIZE = 4;
    reg [3:0] sent_packets;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_window <= 0;
            packet_to_send <= 0;
            window_valid <= 0;
            sent_packets <= 0;
        end else begin
            if (send && (current_window < MAX_WINDOW_SIZE)) begin
                packet_to_send <= packet_to_send + 1;
                current_window <= current_window + 1;
                window_valid <= 1;
            end
            
            if (ack && (current_window > 0)) begin
                current_window <= current_window - 1;
                window_valid <= (current_window > 0);
                sent_packets <= sent_packets + 1;
            end

            if (current_window >= MAX_WINDOW_SIZE) begin
                window_valid <= 0;
            end
        end
    end
endmodule