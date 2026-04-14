module dma_controller (
    input clk,
    input reset,
    input req_chan0,
    input req_chan1,
    input [7:0] src_addr_chan0,
    input [7:0] dest_addr_chan0,
    input [7:0] data_size_chan0,
    input [7:0] src_addr_chan1,
    input [7:0] dest_addr_chan1,
    input [7:0] data_size_chan1,
    output reg ack_chan0,
    output reg ack_chan1,
    output reg transfer_done
);
    reg [2:0] state; // 0: idle, 1: transfer0, 2: transfer1
    reg [7:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            ack_chan0 <= 0;
            ack_chan1 <= 0;
            transfer_done <= 0;
            count <= 0;
        end else begin
            case (state)
                0: begin
                    transfer_done <= 0;
                    if (req_chan0) begin
                        state <= 1;
                        ack_chan0 <= 1;
                        count <= 0;
                    end else if (req_chan1) begin
                        state <= 2;
                        ack_chan1 <= 1;
                        count <= 0;
                    end
                end
                1: begin
                    if (count < data_size_chan0) begin
                        // Simulate data transfer
                        count <= count + 1;
                    end else begin
                        transfer_done <= 1;
                        state <= 0;
                        ack_chan0 <= 0;
                    end
                end
                2: begin
                    if (count < data_size_chan1) begin
                        // Simulate data transfer
                        count <= count + 1;
                    end else begin
                        transfer_done <= 1;
                        state <= 0;
                        ack_chan1 <= 0;
                    end
                end
            endcase
        end
    end
endmodule