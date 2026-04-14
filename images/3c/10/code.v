module dma_controller (
    input clk,
    input rst,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    output reg [7:0] data_out,
    output reg done
);
    reg [2:0] state;
    reg [7:0] memory [255:0]; // Simple memory array

    parameter IDLE = 3'b000;
    parameter READ = 3'b001;
    parameter WRITE = 3'b010;
    parameter DONE = 3'b011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= READ;
                        done <= 0;
                    end
                end
                READ: begin
                    data_out <= memory[src_addr]; // Read from source address
                    state <= WRITE;
                end
                WRITE: begin
                    memory[dest_addr] <= data_out; // Write to destination address
                    state <= DONE;
                end
                DONE: begin
                    done <= 1; // Indicate transfer complete
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule