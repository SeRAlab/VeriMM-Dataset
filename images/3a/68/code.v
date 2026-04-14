module sliding_window_protocol #(parameter WINDOW_SIZE = 4, parameter DATA_WIDTH = 8) (
    input clk,
    input reset,
    input send_packet,
    input ack,
    output reg [DATA_WIDTH-1:0] packet_out,
    output reg [DATA_WIDTH-1:0] current_window,
    output reg full,
    output reg empty
);
    reg [DATA_WIDTH-1:0] packets [0:WINDOW_SIZE-1];
    reg [2:0] next_send_index;
    reg [2:0] next_ack_index;
    reg [2:0] window_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_send_index <= 0;
            next_ack_index <= 0;
            window_count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (send_packet && window_count < WINDOW_SIZE) begin
                packets[next_send_index] <= next_send_index; // Sending packet
                packet_out <= packets[next_send_index];
                next_send_index <= (next_send_index + 1) % WINDOW_SIZE;
                window_count <= window_count + 1;
                empty <= 0;
                full <= (window_count + 1 == WINDOW_SIZE);
            end

            if (ack && window_count > 0) begin
                next_ack_index <= (next_ack_index + 1) % WINDOW_SIZE; // Acknowledging packet
                window_count <= window_count - 1;
                full <= (window_count == WINDOW_SIZE);
                empty <= (window_count - 1 == 0);
            end
        end
    end
endmodule