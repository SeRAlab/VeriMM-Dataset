module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    inout wire [7:0] data,
    output reg done
);

reg [7:0] internal_src_addr;
reg [7:0] internal_dest_addr;
reg [2:0] state; // State machine for the DMA controller

localparam IDLE = 3'b000,
           READ = 3'b001,
           WRITE = 3'b010,
           DONE = 3'b011;

assign data = (state == READ) ? memory[internal_src_addr] : 8'bz;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    internal_src_addr <= src_addr;
                    internal_dest_addr <= dest_addr;
                    state <= READ;
                    done <= 0;
                end
            end
            READ: begin
                state <= WRITE;
            end
            WRITE: begin
                memory[internal_dest_addr] <= data;
                state <= DONE;
            end
            DONE: begin
                done <= 1;
                state <= IDLE;
            end
        endcase
    end
end

// Dummy memory for simulation purpose
reg [7:0] memory [0:255];

endmodule