module dma_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] num_bytes,
    input wire [15:0] src_addr,
    input wire [15:0] dest_addr,
    output reg done,
    output reg read,
    output reg write
);
    reg [7:0] bytes_remaining;
    reg [15:0] current_src_addr;
    reg [15:0] current_dest_addr;
    reg [1:0] state;

    // State encoding
    localparam IDLE = 2'b00,
               READ = 2'b01,
               WRITE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
            read <= 0;
            write <= 0;
            bytes_remaining <= 0;
            current_src_addr <= 0;
            current_dest_addr <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        bytes_remaining <= num_bytes;
                        current_src_addr <= src_addr;
                        current_dest_addr <= dest_addr;
                        state <= READ;
                        done <= 0;
                    end
                end
                READ: begin
                    read <= 1;
                    // Simulating the read operation (you would actually read memory here)
                    // After reading, move to WRITE state
                    if (bytes_remaining > 0) begin
                        bytes_remaining <= bytes_remaining - 1;
                        state <= WRITE;
                    end else begin
                        done <= 1;
                        state <= IDLE;
                    end
                end
                WRITE: begin
                    write <= 1;
                    // Simulating the write operation (you would actually write to memory here)
                    state <= READ; // Move back to READ to continue the transfer
                end
            endcase
        end
    end
endmodule