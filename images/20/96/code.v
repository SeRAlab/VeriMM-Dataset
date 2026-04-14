module dma_controller(
    input clk,
    input reset,
    input start,
    input [7:0] channel_enable, // 8-bit input to enable channels
    output reg [7:0] channel_active // 8-bit output indicating active channels
);

    reg [2:0] state; // State of the FSM
    reg [2:0] current_channel; // Current channel being processed

    localparam IDLE = 3'b000,
               TRANSFER = 3'b001,
               COMPLETE = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            channel_active <= 8'b00000000;
            current_channel <= 3'b000;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        current_channel <= 3'b000;
                        state <= TRANSFER;
                    end
                end
                TRANSFER: begin
                    if (current_channel < 3'b111 && channel_enable[current_channel]) begin
                        channel_active[current_channel] <= 1'b1; // Mark channel as active
                        current_channel <= current_channel + 1;
                    end else begin
                        state <= COMPLETE;
                    end
                end
                COMPLETE: begin
                    channel_active <= 8'b00000000; // Reset active channels
                    state <= IDLE; // Go back to IDLE state
                end
            endcase
        end
    end
endmodule