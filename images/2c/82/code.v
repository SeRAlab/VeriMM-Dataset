module dma_controller(
    input clk,
    input reset,
    input start,
    input rw, // 0 for read, 1 for write
    input [7:0] data_in, // Data from memory or peripheral
    output reg [7:0] data_out, // Data to memory or peripheral
    output reg done
);
    reg [2:0] state; // State register
    reg [7:0] address; // Address for the transfer
    
    localparam IDLE = 3'b000,
               READ = 3'b001,
               WRITE = 3'b010,
               DONE = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            data_out <= 0;
            address <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= rw ? WRITE : READ;
                        done <= 0;
                    end
                end
                READ: begin
                    data_out <= data_in; // Read data
                    state <= DONE;
                end
                WRITE: begin
                    // Write data logic (to memory or peripheral)
                    state <= DONE;
                end
                DONE: begin
                    done <= 1; // Signal that transfer is complete
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule