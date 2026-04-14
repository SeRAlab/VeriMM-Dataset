module dma_controller (
    input wire clk,
    input wire enable,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    output reg status,
    output reg [7:0] data_out
);
    reg [1:0] state;
    localparam IDLE = 2'b00, TRANSFER = 2'b01, DONE = 2'b10;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (enable) begin
                    state <= TRANSFER;
                    status <= 1; // Transfer is ongoing
                end
            end
            TRANSFER: begin
                // Simulate data transfer
                data_out <= src_addr; // Here we assume the data is at the src_addr
                state <= DONE;
            end
            DONE: begin
                status <= 0; // Transfer is done
                state <= IDLE;
            end
        endcase
    end
endmodule