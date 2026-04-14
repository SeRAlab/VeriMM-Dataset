module sliding_window_protocol (
    input clk,
    input reset,
    input ack,                    // Acknowledgment signal from receiver
    output reg [3:0] send_frame,  // Frame to be sent
    output reg [3:0] window_start, // Start of the current window
    output reg [3:0] window_end    // End of the current window
);
    parameter WINDOW_SIZE = 4;
    parameter FRAME_COUNT = 16;
    
    reg [3:0] next_frame;
    
    initial begin
        send_frame = 0;
        window_start = 0;
        window_end = WINDOW_SIZE - 1;
        next_frame = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            send_frame <= 0;
            window_start <= 0;
            window_end <= WINDOW_SIZE - 1;
            next_frame <= 0;
        end else begin
            if (ack && (ack >= window_start) && (ack <= window_end)) begin
                window_start <= window_start + 1;
                window_end <= (window_end + 1) % FRAME_COUNT;
            end
            
            if (next_frame < window_start + WINDOW_SIZE) begin
                send_frame <= next_frame;
                next_frame <= next_frame + 1;
            end
        end
    end
endmodule