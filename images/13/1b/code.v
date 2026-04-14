module dma_controller (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [3:0] req, // Request lines for 4 channels
    output reg [3:0] ack,  // Acknowledge lines for 4 channels
    output reg [1:0] state // State: 0 - Idle, 1 - Transfer, 2 - Wait
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam TRANSFER = 2'b01;
    localparam WAIT = 2'b10;

    reg [1:0] next_state;

    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ack <= 4'b0000;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (enable && |req) begin
                    next_state = TRANSFER;
                    ack = req; // Acknowledge the channel that requested
                end else begin
                    next_state = IDLE;
                    ack = 4'b0000;
                end
            end
            TRANSFER: begin
                // Simulate transfer logic
                next_state = WAIT;
                ack = 4'b1111; // All channels acknowledged for simplicity
            end
            WAIT: begin
                if (!enable) begin
                    next_state = IDLE;
                    ack = 4'b0000;
                end else begin
                    next_state = WAIT;
                end
            end
            default: begin
                next_state = IDLE;
                ack = 4'b0000;
            end
        endcase
    end
endmodule