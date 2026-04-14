module sliding_window_protocol (
    input wire clk,
    input wire reset,
    input wire ack,
    input wire [7:0] packet_data,
    output reg [7:0] sent_packet,
    output reg send_valid
);

    parameter WINDOW_SIZE = 4;
    reg [1:0] window_count;
    reg [1:0] next_packet_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window_count <= 0;
            next_packet_index <= 0;
            sent_packet <= 0;
            send_valid <= 0;
        end else begin
            if (ack && window_count > 0) begin
                window_count <= window_count - 1;
                next_packet_index <= next_packet_index + 1;
            end
            
            if (window_count < WINDOW_SIZE) begin
                sent_packet <= packet_data;
                send_valid <= 1;
                window_count <= window_count + 1;
            end else begin
                send_valid <= 0;
            end
        end
    end
endmodule