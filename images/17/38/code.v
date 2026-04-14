module dma_controller (
    input wire [3:0] req,
    input wire clk,
    input wire rst,
    output reg [3:0] ack,
    output reg [1:0] selected_channel
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 4'b0000;
            selected_channel <= 2'b00;
        end else begin
            selected_channel <= (req[3] ? 2'b11 : 
                                 req[2] ? 2'b10 : 
                                 req[1] ? 2'b01 : 
                                 req[0] ? 2'b00 : 
                                 2'b00);
            ack <= 4'b0000;
            ack[selected_channel] <= 1'b1;
        end
    end
endmodule