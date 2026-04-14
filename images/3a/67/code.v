module dma_controller (
    input wire clk,
    input wire reset,
    input wire channel1,
    input wire channel2,
    input wire [7:0] addr1,
    input wire [7:0] addr2,
    input wire start_transfer,
    output reg [7:0] data_out,
    output reg transfer_done
);
    reg [1:0] current_channel;
    reg [7:0] data_memory [0:255]; // Example data memory

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_channel <= 0;
            transfer_done <= 0;
            data_out <= 0;
        end else if (start_transfer) begin
            if (current_channel == 0 && channel1) begin
                data_out <= data_memory[addr1];
                current_channel <= 1;
                transfer_done <= 0;
            end else if (current_channel == 1 && channel2) begin
                data_out <= data_memory[addr2];
                current_channel <= 0;
                transfer_done <= 1;
            end
        end
    end
endmodule