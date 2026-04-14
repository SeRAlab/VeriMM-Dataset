module sliding_window_sender #(
    parameter N = 4
) (
    input wire clk,
    input wire reset,
    input wire send_packet,
    input wire ack_received,
    output reg [N-1:0] sent_packets,
    output reg [N-1:0] window
);
    reg [N-1:0] current_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_count <= 0;
            sent_packets <= 0;
            window <= 0;
        end else begin
            if (send_packet && (current_count < N)) begin
                sent_packets[current_count] <= 1;
                window <= sent_packets;
                current_count <= current_count + 1;
            end
            
            if (ack_received && (current_count > 0)) begin
                sent_packets[0] <= 0;
                sent_packets <= sent_packets >> 1; // shift window
                current_count <= current_count - 1;
            end
        end
    end
endmodule