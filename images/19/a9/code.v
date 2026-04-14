module sliding_window_protocol #(parameter N = 4) (
    input clk,
    input rst,
    input ack,
    output reg send,
    output reg [N-1:0] packets_sent,
    output reg [N-1:0] packets_received
);
    reg [N-1:0] window; // window for the sliding window protocol
    reg [N-1:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            packets_sent <= 0;
            packets_received <= 0;
            counter <= 0;
            send <= 0;
            window <= 0;
        end else begin
            if (counter < N) begin
                send <= 1; // allow sending
                packets_sent <= packets_sent + 1;
                window <= window + 1;
                counter <= counter + 1;
            end else begin
                send <= 0; // stop sending until ACK received
            end
            
            if (ack) begin
                packets_received <= packets_received + 1;
                window <= window - 1;
                counter <= counter - 1; // decrement the counter when ACK is received
            end
        end
    end
endmodule