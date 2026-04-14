module dma_controller (
    input clk,
    input reset,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] data,
    output reg done,
    output reg [7:0] dest_data,
    output reg [7:0] current_src_addr,
    output reg [7:0] current_dest_addr
);
    reg [2:0] state;
    parameter IDLE = 3'b000, TRANSFER = 3'b001, COMPLETE = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            current_src_addr <= 0;
            current_dest_addr <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        current_src_addr <= src_addr;
                        current_dest_addr <= dest_addr;
                        state <= TRANSFER;
                        done <= 0;
                    end
                end
                TRANSFER: begin
                    dest_data <= data; // Simulating data transfer
                    current_src_addr <= current_src_addr + 1;
                    current_dest_addr <= current_dest_addr + 1;
                    state <= COMPLETE;
                end
                COMPLETE: begin
                    done <= 1;
                    state <= IDLE; // Go back to IDLE after completion
                end
            endcase
        end
    end
endmodule