module dma_controller(
    input clk,
    input rst,
    input [7:0] enable,           // Channel enable signals
    input [7:0] request,          // Transfer request signals
    input [7:0] transfer_size,    // Size of data to transfer for each channel
    output reg [7:0] active_channel, // Current active channel
    output reg transfer_complete    // Transfer completion signal
);
    reg [2:0] state;               // State variable
    reg [2:0] channel_count;       // Counter for the active channel

    localparam IDLE = 3'b000,
               TRANSFER = 3'b001,
               COMPLETE = 3'b010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            active_channel <= 8'b0;
            transfer_complete <= 1'b0;
            channel_count <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (request & enable) begin
                        active_channel <= request & enable; // Select active channel
                        state <= TRANSFER;
                    end
                end

                TRANSFER: begin
                    if (channel_count < transfer_size[channel_count]) begin
                        channel_count <= channel_count + 1; // Increment transfer size
                    end else begin
                        state <= COMPLETE; // Move to complete state
                    end
                end

                COMPLETE: begin
                    transfer_complete <= 1'b1; // Indicate transfer completion
                    state <= IDLE; // Return to idle state
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule