module dma_controller (
    input wire clk,
    input wire rst,
    input wire read_req,
    input wire write_req,
    input wire [7:0] addr,
    input wire [7:0] write_data,
    output reg [7:0] read_data,
    output reg ready
);
    reg [1:0] state; // 0: idle, 1: read, 2: write
    reg [7:0] memory [0:255]; // Simple memory array

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00; // idle state
            ready <= 1'b0;
            read_data <= 8'b0;
        end else begin
            case (state)
                2'b00: begin // idle
                    ready <= 1'b0;
                    if (read_req) begin
                        state <= 2'b01; // transition to read state
                    end else if (write_req) begin
                        state <= 2'b10; // transition to write state
                    end
                end
                2'b01: begin // read
                    read_data <= memory[addr]; // read from memory
                    ready <= 1'b1;
                    state <= 2'b00; // return to idle
                end
                2'b10: begin // write
                    memory[addr] <= write_data; // write to memory
                    ready <= 1'b1;
                    state <= 2'b00; // return to idle
                end
            endcase
        end
    end
endmodule