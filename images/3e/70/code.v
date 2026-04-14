module sliding_window_receiver(
    input clk,
    input reset,
    input [3:0] packet_num, // 4-bit packet number
    input packet_valid,      // indicates if the packet is valid
    output reg [3:0] ack_num // acknowledge the last valid packet
);
    reg [3:0] window_start;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack_num <= 4'b0000;
            window_start <= 4'b0000;
        end else if (packet_valid) begin
            if (packet_num >= window_start && packet_num < window_start + 4) begin
                ack_num <= packet_num; // acknowledge the received packet
                // Update window if necessary
                if (packet_num == window_start + 3) begin
                    window_start <= window_start + 1; // slide the window
                end
            end
        end
    end
endmodule