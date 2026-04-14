module dma_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] request,  // 4 request lines
    output reg [3:0] grant,     // 4 grant lines
    output reg ack              // Acknowledge signal
);

    reg [1:0] current_state, next_state;

    localparam IDLE = 2'd0,
               GRANT = 2'd1,
               ACK = 2'd2;

    // State machine for DMA controller
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            grant <= 4'b0000;
            ack <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: begin
                grant = 4'b0000;
                ack = 1'b0;
                if (request != 4'b0000) begin
                    next_state = GRANT;
                    grant = request;  // Grant access to the requested channel
                end else begin
                    next_state = IDLE;
                end
            end
            GRANT: begin
                ack = 1'b0;
                next_state = ACK;
            end
            ACK: begin
                ack = 1'b1;  // Acknowledge the request
                next_state = IDLE;  // Go back to IDLE state
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule