module sliding_window_protocol (
    input wire clk,
    input wire rst,
    input wire send_packet,
    input wire ack_packet,
    output reg [3:0] window_status,
    output reg [3:0] packets_sent
);
    parameter WINDOW_SIZE = 4;
    reg [3:0] send_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            window_status <= 0;
            packets_sent <= 0;
            send_count <= 0;
        end else begin
            if (send_packet && (send_count < WINDOW_SIZE)) begin
                window_status <= window_status + 1;
                packets_sent <= packets_sent + 1;
                send_count <= send_count + 1;
            end
            if (ack_packet && (send_count > 0)) begin
                window_status <= window_status - 1;
                send_count <= send_count - 1;
            end
        end
    end
endmodule