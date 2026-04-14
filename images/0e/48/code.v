module dma_controller (
    input clk,
    input reset,
    input [2:0] channel_select,
    input start,
    input [7:0] source_addr,
    input [7:0] dest_addr,
    output reg done
);
    reg [7:0] data_register;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
            data_register <= 8'b0;
        end else if (start) begin
            // Simulate data transfer
            data_register <= source_addr;  // Simulating data read from source
            done <= 1;  // Indicate that the operation is done
        end
    end
endmodule