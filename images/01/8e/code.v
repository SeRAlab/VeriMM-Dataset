module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [7:0] data,
    output reg busy,
    output reg done,
    output reg [7:0] read_data
);
    reg [1:0] state;
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10, COMPLETE = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            done <= 0;
            read_data <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        busy <= 1;
                        done <= 0;
                        state <= READ;
                    end
                end
                READ: begin
                    read_data <= data; // Simulate reading from src_addr
                    state <= WRITE;
                end
                WRITE: begin
                    busy <= 1; // Simulate writing to dest_addr
                    state <= COMPLETE;
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