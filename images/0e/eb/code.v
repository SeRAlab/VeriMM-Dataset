module dma_controller (
    input clk,
    input reset,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] transfer_size,
    output reg busy,
    output reg done
);
    reg [7:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            done <= 0;
            counter <= 0;
        end else if (start && !busy) begin
            busy <= 1;
            counter <= transfer_size;
            done <= 0;
        end else if (busy) begin
            if (counter > 0) begin
                // Simulate data transfer (not implementing actual memory access)
                counter <= counter - 1;
            end else begin
                busy <= 0;
                done <= 1;
            end
        end
    end
endmodule