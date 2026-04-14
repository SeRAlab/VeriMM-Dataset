module dma_controller (
    input clk,
    input reset,
    input start,
    input [2:0] channel,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg busy
);
    reg [7:0] memory [0:7]; // Simulated memory for 8 channels
    reg [2:0] current_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            data_out <= 0;
        end else if (start) begin
            busy <= 1;
            current_channel <= channel;
            memory[current_channel] <= data_in; // Transfer data
            data_out <= memory[current_channel]; // Output the data
            busy <= 0; // Transfer complete
        end
    end
endmodule