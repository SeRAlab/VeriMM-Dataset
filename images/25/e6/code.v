module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg transfer_done
);
    reg [3:0] state;
    parameter IDLE = 4'b0000, TRANSFER = 4'b0001, DONE = 4'b0010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_out <= 8'b0;
            transfer_done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSFER;
                        data_out <= data_in; // Start transferring data
                        transfer_done <= 1'b0;
                    end
                end
                TRANSFER: begin
                    // Here you can simulate chunk data transfer
                    // For simplicity, we just proceed to DONE after one cycle
                    state <= DONE;
                end
                DONE: begin
                    transfer_done <= 1'b1; // Transfer is done
                    state <= IDLE; // Go back to IDLE
                end
            endcase
        end
    end
endmodule