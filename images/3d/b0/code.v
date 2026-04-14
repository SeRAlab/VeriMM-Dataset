module dma_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] req,  // request signals from channels 0 to 3
    output reg [3:0] ack,   // acknowledge signals for channels 0 to 3
    input wire [7:0] data_in,  // data input from memory
    output reg [7:0] data_out  // data output to peripheral
);
    reg [1:0] current_channel;  // 2-bit register to hold the current channel

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 4'b0000;
            data_out <= 8'b00000000;
            current_channel <= 2'b00;
        end else begin
            ack <= 4'b0000;  // Reset acknowledge signals
            if (req[0]) begin
                ack[0] <= 1'b1;  // Grant channel 0
                current_channel <= 2'b00;
            end else if (req[1]) begin
                ack[1] <= 1'b1;  // Grant channel 1
                current_channel <= 2'b01;
            end else if (req[2]) begin
                ack[2] <= 1'b1;  // Grant channel 2
                current_channel <= 2'b10;
            end else if (req[3]) begin
                ack[3] <= 1'b1;  // Grant channel 3
                current_channel <= 2'b11;
            end
            
            // Data transfer logic based on the granted channel
            case (current_channel)
                2'b00: data_out <= data_in;  // Transfer data for channel 0
                2'b01: data_out <= data_in;  // Transfer data for channel 1
                2'b10: data_out <= data_in;  // Transfer data for channel 2
                2'b11: data_out <= data_in;  // Transfer data for channel 3
                default: data_out <= 8'b00000000;
            endcase
        end
    end
endmodule