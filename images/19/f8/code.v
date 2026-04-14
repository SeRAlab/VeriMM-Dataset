module sliding_window_protocol(
    input clk,
    input rst,
    input send_enable,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg ack,
    output reg [3:0] window
);
    parameter WINDOW_SIZE = 4;
    reg [3:0] sent_count;
    reg [3:0] ack_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sent_count <= 0;
            ack_count <= 0;
            window <= WINDOW_SIZE;
            ack <= 0;
        end else begin
            if (send_enable && window > 0) begin
                data_out <= data_in;
                sent_count <= sent_count + 1;
                window <= window - 1;
                ack <= 0; // Reset ack until acknowledged
            end
            if (ack_count < sent_count) begin
                ack <= 1; // Send acknowledgment for received data
                ack_count <= ack_count + 1;
                window <= window + 1; // Allow sending of a new frame
            end
        end
    end
endmodule