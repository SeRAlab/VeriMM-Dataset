module dma_controller (
    input wire clk,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    output reg done,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:255]; // A simple memory array
    reg [7:0] current_src;
    reg [7:0] current_dest;
    reg [3:0] state;

    // States
    parameter IDLE = 0, TRANSFER = 1, COMPLETE = 2;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (start) begin
                    current_src <= src_addr;
                    current_dest <= dest_addr;
                    state <= TRANSFER;
                    done <= 0;
                end
            end
            TRANSFER: begin
                data_out <= memory[current_src]; // Read from source
                memory[current_dest] <= data_out; // Write to destination
                current_src <= current_src + 1;
                current_dest <= current_dest + 1;

                // Check for completion (for this example, assume 5 bytes transfer)
                if (current_src == src_addr + 5) begin
                    state <= COMPLETE;
                end
            end
            COMPLETE: begin
                done <= 1; // Signal transfer complete
                state <= IDLE; // Go back to idle
            end
        endcase
    end
endmodule