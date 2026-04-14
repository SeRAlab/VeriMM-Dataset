module dma_controller (
    input clk,
    input reset,
    input req_a,
    input req_b,
    input ack_a,
    input ack_b,
    input [7:0] data_in_a,
    input [7:0] data_in_b,
    output reg [7:0] data_out,
    output reg active_channel
);
    reg state; // 0 for idle, 1 for transferring

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            data_out <= 0;
            active_channel <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    if (req_a) begin
                        active_channel <= 0;
                        data_out <= data_in_a;
                        state <= 1; // Transition to transferring state
                    end else if (req_b) begin
                        active_channel <= 1;
                        data_out <= data_in_b;
                        state <= 1; // Transition to transferring state
                    end
                end
                1: begin // Transferring state
                    if (active_channel == 0 && ack_a) begin
                        state <= 0; // Go back to idle
                    end else if (active_channel == 1 && ack_b) begin
                        state <= 0; // Go back to idle
                    end
                end
            endcase
        end
    end
endmodule