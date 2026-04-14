module dma_controller (
    input clk,
    input rst,
    input start,
    input [3:0] transfer_size,
    output reg done,
    output reg [3:0] data_out,
    input [3:0] data_in
);

reg [3:0] counter;
reg state;

parameter IDLE = 1'b0;
parameter TRANSFER = 1'b1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 4'b0000;
        done <= 1'b0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                done <= 1'b0;
                if (start) begin
                    counter <= transfer_size;
                    state <= TRANSFER;
                end
            end
            TRANSFER: begin
                if (counter > 0) begin
                    data_out <= data_in; // Simulate data transfer
                    counter <= counter - 1;
                end else begin
                    done <= 1'b1;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule