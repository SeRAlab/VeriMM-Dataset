module dma_controller(
    input clk,
    input reset,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] data_in,
    output reg done,
    output reg [7:0] data_out
);
    reg [1:0] state;
    parameter IDLE = 2'b00, TRANSFER = 2'b01, COMPLETE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            data_out <= 8'b0;
        end else begin
            case(state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSFER;
                        done <= 0;
                    end
                end
                TRANSFER: begin
                    data_out <= data_in; // Simulate data transfer
                    state <= COMPLETE;
                end
                COMPLETE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule