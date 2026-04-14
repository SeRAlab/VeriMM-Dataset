module sliding_window_controller (
    input clk,
    input reset,
    input enable,
    input packet_arrival,
    output reg can_send,
    output reg can_receive
);
    reg [1:0] state; // 2-bit state to represent 0 to 3 (window size)
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Reset state to 0
            can_send <= 0;
            can_receive <= 0;
        end else if (enable) begin
            // Manage sending and receiving packets
            if (packet_arrival) begin
                if (state < 2'b11) begin
                    state <= state + 1; // Increment state
                    can_send <= 1; // Can send a packet
                end else begin
                    can_send <= 0; // Cannot send, window full
                end
            end else begin
                if (state > 2'b00) begin
                    state <= state - 1; // Decrement state
                    can_receive <= 1; // Can receive a packet
                end else begin
                    can_receive <= 0; // No packets to receive
                end
            end
        end
    end
endmodule