module sliding_window_protocol(
    input clk,
    input reset,
    input send_packet,
    input ack,
    output reg [2:0] window_count,
    output reg sending
);

parameter WINDOW_SIZE = 4;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        window_count <= 0;
        sending <= 0;
    end else begin
        if (send_packet && window_count < WINDOW_SIZE) begin
            sending <= 1;
            window_count <= window_count + 1;
        end else if (ack && window_count > 0) begin
            sending <= 0;
            window_count <= window_count - 1;
        end else begin
            sending <= 0;
        end
    end
end

endmodule