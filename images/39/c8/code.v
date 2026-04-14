module dma_controller (
    input wire clk,
    input wire start,
    input wire [1:0] channel_select,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg busy
);

    reg [7:0] channel_data [3:0]; // storage for each channel
    reg [1:0] current_channel;

    always @(posedge clk) begin
        if (start) begin
            current_channel <= channel_select;
            busy <= 1'b1; // Set busy to true
        end
        
        if (busy) begin
            data_out <= channel_data[current_channel]; // Transfer data
            busy <= 1'b0; // Clear busy after transfer
        end
    end

    // Assuming some mechanism is there to load data into channel_data
    always @(posedge clk) begin
        if (start) begin
            channel_data[channel_select] <= data_in; // Load incoming data to the selected channel
        end
    end
endmodule