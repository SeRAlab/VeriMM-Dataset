module dma_controller(
    input wire clk,
    input wire rst,
    input wire sel, // channel select: 0 for channel 0, 1 for channel 1
    input wire [31:0] src_addr,
    input wire [31:0] dst_addr,
    input wire start,
    output reg transfer_active,
    output reg [1:0] active_channel
);
    
    reg [1:0] state; // 00: idle, 01: transfer channel 0, 10: transfer channel 1

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00; // reset state
            transfer_active <= 0;
            active_channel <= 2'b00;
        end else begin
            case (state)
                2'b00: begin // idle state
                    if (start) begin
                        state <= (sel) ? 2'b10 : 2'b01; // select channel
                        transfer_active <= 1;
                        active_channel <= (sel) ? 2'b10 : 2'b01;
                    end
                end
                2'b01: begin // transferring channel 0
                    // Code to perform data transfer (omitted for simplicity)
                    state <= 2'b00; // go back to idle after transfer
                    transfer_active <= 0;
                end
                2'b10: begin // transferring channel 1
                    // Code to perform data transfer (omitted for simplicity)
                    state <= 2'b00; // go back to idle after transfer
                    transfer_active <= 0;
                end
            endcase
        end
    end
endmodule