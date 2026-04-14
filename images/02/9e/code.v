module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] address,
    output reg busy,
    output reg [7:0] data_out
);
    reg [2:0] current_channel;
    reg [7:0] data_memory [0:7]; // Simulated data for each channel

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            current_channel <= 0;
            data_out <= 0;
        end else if (start) begin
            busy <= 1;
            data_out <= data_memory[current_channel];
            current_channel <= (current_channel + 1) % 8; // Round-robin
        end else begin
            busy <= 0;
        end
    end
endmodule