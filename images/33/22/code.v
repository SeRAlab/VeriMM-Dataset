module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [2:0] channel_addr,
    output reg [7:0] active_channel,
    output reg complete
);
    reg [2:0] current_channel;
    reg [2:0] state; // 0: idle, 1: active, 2: complete

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            active_channel <= 8'b00000000;
            complete <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // idle
                    complete <= 0;
                    if (start) begin
                        current_channel <= channel_addr;
                        active_channel <= 1 << current_channel; // activate the selected channel
                        state <= 1; // move to active state
                    end
                end
                1: begin // active
                    // Simulate transfer with a simple delay
                    // In actual hardware, this would be the DMA transfer logic
                    state <= 2; // move to complete state after transfer
                end
                2: begin // complete
                    complete <= 1;
                    state <= 0; // return to idle
                end
            endcase
        end
    end
endmodule