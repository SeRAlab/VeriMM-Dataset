module dma_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    output reg done,
    output reg [7:0] data_out
);

    reg [7:0] memory [0:255]; // Simple memory
    reg [3:0] state; // State variable
    reg [3:0] count; // Counter for transfer

    localparam IDLE = 0, READ = 1, WRITE = 2, DONE = 3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        count <= 0;
                        state <= READ;
                        done <= 0;
                    end
                end
                READ: begin
                    data_out <= memory[src_addr + count];
                    state <= WRITE;
                end
                WRITE: begin
                    memory[dest_addr + count] <= data_out;
                    count <= count + 1;
                    if (count == 4'd15) begin // transfer 16 bytes
                        state <= DONE;
                    end else begin
                        state <= READ;
                    end
                end
                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule