module sliding_window_protocol (
    input wire clk,
    input wire rst,
    input wire send_packet,
    input wire [7:0] packet_data,
    output reg [7:0] sent_packet,
    output reg ack,
    output reg [1:0] window_status // 00: idle, 01: sending, 10: acknowledged
);
    reg [1:0] send_ptr; // Pointer for sending packets
    reg [1:0] ack_ptr;  // Pointer for acknowledged packets
    reg [3:0] window [0:3]; // Sliding window with size 4
    reg [1:0] count; // Count of sent packets

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            send_ptr <= 0;
            ack_ptr <= 0;
            count <= 0;
            window_status <= 2'b00;
            ack <= 0;
            sent_packet <= 8'b0;
        end else begin
            case (window_status)
                2'b00: begin // idle
                    if (send_packet && count < 4) begin
                        window[send_ptr] <= packet_data;
                        sent_packet <= packet_data;
                        window_status <= 2'b01; // change to sending
                        count <= count + 1;
                    end
                end
                2'b01: begin // sending
                    if (count > 0) begin
                        ack <= 1; // Send acknowledgment
                        window_status <= 2'b10; // change to acknowledged
                    end
                end
                2'b10: begin // acknowledged
                    ack <= 0; // clear ack
                    ack_ptr <= (ack_ptr + 1) % 4; // move ack pointer
                    count <= count - 1; // decrease count
                    send_ptr <= (send_ptr + 1) % 4; // move send pointer
                    if (count == 0) begin
                        window_status <= 2'b00; // back to idle
                    end
                end
            endcase
        end
    end
endmodule