module sliding_window_controller(
    input clk,
    input rst,
    input send_req,
    input [7:0] packet_in,
    output reg packet_sent,
    output reg packet_received,
    output reg [3:0] window_pos
);
    parameter WINDOW_SIZE = 4;
    
    initial begin
        window_pos = 0;
        packet_sent = 0;
        packet_received = 0;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            window_pos <= 0;
            packet_sent <= 0;
            packet_received <= 0;
        end else begin
            if (send_req && window_pos < WINDOW_SIZE) begin
                packet_sent <= 1;
                window_pos <= window_pos + 1;
            end else begin
                packet_sent <= 0;
            end
            
            // Simulate receiving a packet (this would normally be determined by an external event)
            if (window_pos > 0) begin
                packet_received <= 1;
                window_pos <= window_pos - 1;
            end else begin
                packet_received <= 0;
            end
        end
    end
endmodule