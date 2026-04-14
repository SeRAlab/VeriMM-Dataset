module dma_controller (
    input wire start,
    input wire [15:0] addr,
    input wire [15:0] data_in,
    input wire clk,
    input wire reset,
    output reg [15:0] data_out,
    output reg done
);

reg [1:0] state;
localparam IDLE = 2'b00,
           TRANSFER = 2'b01,
           DONE = 2'b10;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data_out <= 16'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    data_out <= data_in; // Transfer data
                    state <= TRANSFER;
                    done <= 1'b0;
                end
            end
            TRANSFER: begin
                // Simulate data transfer to the address (not implemented in hardware)
                state <= DONE;
            end
            DONE: begin
                done <= 1'b1; // Indicate transfer is done
                state <= IDLE; // Go back to IDLE
            end
        endcase
    end
end

endmodule