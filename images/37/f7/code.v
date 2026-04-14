module dma_controller (
    input wire clk,
    input wire start,
    input wire [2:0] channel_select,
    output reg busy,
    output reg done
);
    reg [2:0] state;
    parameter IDLE = 3'b000, TRANSFER = 3'b001, DONE = 3'b010;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                busy <= 0;
                done <= 0;
                if (start) begin
                    state <= TRANSFER;
                    busy <= 1;
                end
            end
            TRANSFER: begin
                // Simulating data transfer
                state <= DONE;
            end
            DONE: begin
                busy <= 0;
                done <= 1;
                state <= IDLE;
            end
        endcase
    end
endmodule