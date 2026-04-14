module dma_controller (
    input clk,
    input rst,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [15:0] data_in,
    output reg done,
    output reg busy,
    output reg error
);
    reg [1:0] state;

    localparam IDLE = 2'b00,
               TRANSFER = 2'b01,
               COMPLETE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
            busy <= 0;
            error <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        busy <= 1;
                        error <= 0;
                        state <= TRANSFER;
                    end
                end
                TRANSFER: begin
                    // Simulate transfer with simple logic
                    // Assume transfer is always successful for this example
                    done <= 0;
                    state <= COMPLETE;
                end
                COMPLETE: begin
                    done <= 1;
                    busy <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule