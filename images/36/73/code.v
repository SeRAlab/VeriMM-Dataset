module dma_controller (
    input clk,
    input reset,
    input start,
    input rw, // read or write: 0 for read, 1 for write
    input [7:0] address,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg busy
);
    reg [1:0] state; // 00: idle, 01: read, 10: write
    reg [7:0] memory [0:255]; // 256 bytes of memory

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            busy <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                2'b00: begin // idle
                    if (start) begin
                        busy <= 1;
                        state <= rw ? 2'b10 : 2'b01; // determine next state
                    end
                end
                2'b01: begin // read
                    data_out <= memory[address];
                    state <= 2'b00; // return to idle
                    busy <= 0;
                end
                2'b10: begin // write
                    memory[address] <= data_in;
                    state <= 2'b00; // return to idle
                    busy <= 0;
                end
            endcase
        end
    end
endmodule