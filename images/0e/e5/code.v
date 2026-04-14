module dma_controller (
    input wire clk,
    input wire rst,
    input wire start_chan1,
    input wire start_chan2,
    input wire [7:0] src_addr_chan1,
    input wire [7:0] src_addr_chan2,
    output reg [7:0] dest_addr_chan1,
    output reg [7:0] dest_addr_chan2,
    output reg transfer_complete_chan1,
    output reg transfer_complete_chan2
);
    reg [2:0] state;
    parameter IDLE = 3'b000, TRANSFER1 = 3'b001, TRANSFER2 = 3'b010, COMPLETE1 = 3'b011, COMPLETE2 = 3'b100;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            dest_addr_chan1 <= 8'b0;
            dest_addr_chan2 <= 8'b0;
            transfer_complete_chan1 <= 0;
            transfer_complete_chan2 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_chan1) begin
                        state <= TRANSFER1;
                    end else if (start_chan2) begin
                        state <= TRANSFER2;
                    end
                end
                TRANSFER1: begin
                    dest_addr_chan1 <= src_addr_chan1; // simulate data transfer
                    state <= COMPLETE1;
                end
                TRANSFER2: begin
                    dest_addr_chan2 <= src_addr_chan2; // simulate data transfer
                    state <= COMPLETE2;
                end
                COMPLETE1: begin
                    transfer_complete_chan1 <= 1;
                    state <= IDLE;
                end
                COMPLETE2: begin
                    transfer_complete_chan2 <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule