module dma_controller(
    input wire clk,
    input wire rst,
    input wire req1,
    input wire req2,
    output reg ack1,
    output reg ack2,
    output reg busy
);
    reg [1:0] state; // 00: idle, 01: channel 1 active, 10: channel 2 active
    reg [1:0] next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;
            busy <= 1'b0;
            ack1 <= 1'b0;
            ack2 <= 1'b0;
        end else begin
            state <= next_state;
            // Acknowledge signals based on state
            case (state)
                2'b00: begin // idle
                    ack1 <= 1'b0;
                    ack2 <= 1'b0;
                    if (req1) begin
                        next_state <= 2'b01; // go to channel 1 active
                        busy <= 1'b1;
                    end else if (req2) begin
                        next_state <= 2'b10; // go to channel 2 active
                        busy <= 1'b1;
                    end else begin
                        next_state <= 2'b00; // remain idle
                    end
                end
                2'b01: begin // channel 1 active
                    ack1 <= 1'b1; // acknowledge channel 1
                    if (!req1) begin
                        next_state <= 2'b00; // back to idle if req1 is gone
                        busy <= 1'b0;
                    end else begin
                        next_state <= 2'b01; // remain in channel 1 active
                    end
                end
                2'b10: begin // channel 2 active
                    ack2 <= 1'b1; // acknowledge channel 2
                    if (!req2) begin
                        next_state <= 2'b00; // back to idle if req2 is gone
                        busy <= 1'b0;
                    end else begin
                        next_state <= 2'b10; // remain in channel 2 active
                    end
                end
                default: next_state <= 2'b00; // default case
            endcase
        end
    end
endmodule