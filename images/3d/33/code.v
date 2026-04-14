module dma_controller (
    input wire start,
    input wire clk,
    input wire rst,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    output reg done
);

reg [7:0] current_src_addr;
reg [7:0] current_dest_addr;
reg [3:0] state;
parameter IDLE = 0, TRANSFER = 1, DONE = 2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        done <= 0;
        data_out <= 16'b0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    current_src_addr <= src_addr;
                    current_dest_addr <= dest_addr;
                    state <= TRANSFER;
                    done <= 0;
                end
            end
            TRANSFER: begin
                data_out <= data_in; // Simulate data transfer
                state <= DONE;
            end
            DONE: begin
                done <= 1; // Signal transfer is complete
                state <= IDLE;
            end
        endcase
    end
end
endmodule