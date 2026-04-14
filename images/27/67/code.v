module sliding_window_protocol (
    input clk,
    input rst,
    input send,
    output reg can_send
);
    reg [1:0] window_count; // 2-bit counter for the window size (0-3)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            window_count <= 2'b00; // Reset the window count
            can_send <= 1'b0;      // Initially cannot send
        end else begin
            if (send && (window_count < 2'b11)) begin
                window_count <= window_count + 2'b01; // Increment window count
                can_send <= 1'b1; // Allow sending
            end else if (!send && (window_count > 2'b00)) begin
                window_count <= window_count - 2'b01; // Decrement window count
                can_send <= 1'b0; // Disallow sending
            end else begin
                can_send <= 1'b0; // Otherwise, disallow sending
            end
        end
    end
endmodule