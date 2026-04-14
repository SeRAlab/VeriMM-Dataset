module dma_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] ack,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg [1:0] sel
);

    reg [1:0] current_channel;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_channel <= 2'b00;
            ack <= 4'b0000;
            data_out <= 8'b00000000;
            sel <= 2'b00;
        end else begin
            if (req != 4'b0000) begin
                ack <= req;
                sel <= current_channel;
                data_out <= data_in;
                current_channel <= (current_channel + 1) % 4;
            end else begin
                ack <= 4'b0000;
            end
        end
    end
endmodule