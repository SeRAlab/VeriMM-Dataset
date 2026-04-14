module dma_controller(
    input clk,
    input reset,
    input start,
    input [7:0] src_addr,
    input [7:0] dst_addr,
    input [15:0] data_in,
    output reg [15:0] data_out,
    output reg done
);
    reg [2:0] state;
    reg [15:0] memory [0:255]; // Simple memory array

    // Define state machine states
    parameter IDLE = 3'b000,
              READ = 3'b001,
              WRITE = 3'b010,
              DONE = 3'b011;

    // State machine to simulate DMA operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= READ;
                    end
                end
                READ: begin
                    data_out <= memory[src_addr]; // Read data from source address
                    state <= WRITE;
                end
                WRITE: begin
                    memory[dst_addr] <= data_out; // Write data to destination address
                    state <= DONE;
                end
                DONE: begin
                    done <= 1; // Indicate transfer completion
                    state <= IDLE; // Go back to IDLE state
                end
            endcase
        end
    end
endmodule