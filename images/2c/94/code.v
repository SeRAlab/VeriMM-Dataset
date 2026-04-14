module dma_controller (
    input clk,
    input reset,
    input [1:0] select,
    input valid,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:3]; // 4 channels

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
        end else if (valid) begin
            memory[select] <= data_in; // Store data in selected channel
            data_out <= memory[select]; // Output the stored data
        end
    end
endmodule