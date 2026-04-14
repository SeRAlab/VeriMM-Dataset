module dma_controller (
    input clk,
    input rst,
    input request,
    input [7:0] transfer_count,
    output reg transfer_done,
    output reg [7:0] current_transfer_count
);
    
    reg state; // 0: idle, 1: transferring

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            transfer_done <= 0;
            current_transfer_count <= 0;
        end else begin
            case (state)
                0: begin // idle state
                    transfer_done <= 0;
                    if (request) begin
                        state <= 1;
                        current_transfer_count <= transfer_count;
                    end
                end
                1: begin // transferring state
                    if (current_transfer_count > 0) begin
                        current_transfer_count <= current_transfer_count - 1;
                    end else begin
                        state <= 0;
                        transfer_done <= 1;
                    end
                end
            endcase
        end
    end
endmodule