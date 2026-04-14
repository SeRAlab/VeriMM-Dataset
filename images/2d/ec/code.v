module dma_controller (
    input clk,
    input rst,
    input start,
    input rw, // rw = 1 for read, rw = 0 for write
    input [7:0] address, // Address for memory
    output reg [7:0] data_out, // Data output
    output reg busy // Busy signal
);
    reg [7:0] memory [0:255]; // Simple memory array
    reg [7:0] data_in; // Input data (for write operation)
    reg [1:0] state; // State of the DMA

    localparam IDLE = 2'b00, ACTIVE = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy <= 0;
            state <= IDLE;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        busy <= 1;
                        if (rw) begin
                            data_out <= memory[address]; // Read from memory
                        end else begin
                            memory[address] <= data_in; // Write to memory
                        end
                        state <= ACTIVE;
                    end
                end
                ACTIVE: begin
                    state <= DONE; // Move to done state
                end
                DONE: begin
                    busy <= 0;
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule