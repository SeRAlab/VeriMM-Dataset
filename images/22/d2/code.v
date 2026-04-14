module dma_controller (
    input clk,
    input reset,
    input start,
    output reg done,
    output reg [2:0] channel
);

    reg [2:0] state;
    parameter IDLE = 3'b000, TRANSFER = 3'b001, COMPLETE = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            channel <= 3'b000;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSFER;
                        channel <= 3'b000;
                        done <= 0;
                    end
                end
                TRANSFER: begin
                    if (channel < 3'b111) begin
                        channel <= channel + 1;
                    end else begin
                        state <= COMPLETE;
                    end
                end
                COMPLETE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule