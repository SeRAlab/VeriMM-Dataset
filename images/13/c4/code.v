module dma_controller (
    input clk,
    input reset,
    input start,
    input channel_select,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] data_in,
    output reg busy,
    output reg [7:0] data_out,
    output reg transfer_complete
);
    reg [1:0] state;
    reg [7:0] source;
    reg [7:0] destination;

    localparam IDLE = 2'b00,
               TRANSFER = 2'b01,
               COMPLETE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            busy <= 0;
            transfer_complete <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        busy <= 1;
                        transfer_complete <= 0;
                        if (channel_select == 0) begin
                            source <= src_addr;
                            destination <= dest_addr;
                        end else begin
                            source <= src_addr + 8'd1; // Just for differentiation
                            destination <= dest_addr + 8'd1; // Just for differentiation
                        end
                        state <= TRANSFER;
                    end
                end
                TRANSFER: begin
                    data_out <= data_in; // Simulating data transfer
                    state <= COMPLETE;
                end
                COMPLETE: begin
                    busy <= 0;
                    transfer_complete <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule