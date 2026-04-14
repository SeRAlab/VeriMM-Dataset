module sliding_window_protocol (
    input wire clk,
    input wire reset,
    input wire send_frame,
    input wire [2:0] ack_frame,
    output reg [2:0] frame_out,
    output reg valid_out
);
    reg [2:0] base; // Base of the window
    reg [2:0] next_frame; // Next frame to send
    reg [2:0] window_size; // Size of the sliding window

    initial begin
        base = 3'b000;
        next_frame = 3'b000;
        window_size = 3'b011; // Window size of 3
        valid_out = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            base <= 3'b000;
            next_frame <= 3'b000;
            valid_out <= 0;
        end else begin
            if (send_frame && (next_frame < base + window_size)) begin
                frame_out <= next_frame;
                valid_out <= 1;
                next_frame <= next_frame + 1;
            end else begin
                valid_out <= 0;
            end
            
            if (ack_frame >= base) begin
                base <= ack_frame + 1; // Slide the window
            end
        end
    end
endmodule