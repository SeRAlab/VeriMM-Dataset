module dma_controller(
    input clk,
    input reset,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] data_in,
    output reg done
);
    reg [7:0] memory [255:0]; // Simple memory simulation
    reg transferring;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
            transferring <= 0;
        end else if (start && !transferring) begin
            memory[dest_addr] <= data_in; // Transfer data
            transferring <= 1;
            done <= 1; // Signal that transfer is done
        end else begin
            done <= 0; // Reset done signal if not transferring
            transferring <= 0;
        end
    end
endmodule