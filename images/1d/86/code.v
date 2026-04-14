module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [7:0] byte_count,
    output reg busy,
    output reg done,
    output reg [7:0] current_byte
);
    reg [7:0] bytes_transferred;
    reg [2:0] state;

    localparam IDLE = 3'b000;
    localparam TRANSFER = 3'b001;
    localparam COMPLETE = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            busy <= 0;
            done <= 0;
            bytes_transferred <= 0;
            current_byte <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        busy <= 1;
                        done <= 0;
                        bytes_transferred <= 0;
                        state <= TRANSFER;
                    end
                end
                TRANSFER: begin
                    if (bytes_transferred < byte_count) begin
                        current_byte <= src_addr + bytes_transferred; // Simulating data transfer
                        bytes_transferred <= bytes_transferred + 1;
                    end else begin
                        state <= COMPLETE;
                    end
                end
                COMPLETE: begin
                    busy <= 0;
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule