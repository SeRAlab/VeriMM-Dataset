module dma_controller (
    input clk,
    input rst,
    input [3:0] request,
    output reg [3:0] acknowledge
);
    reg [1:0] current_channel;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_channel <= 2'b00;
            acknowledge <= 4'b0000;
        end else begin
            if (request != 4'b0000) begin
                current_channel <= request[3] ? 2'b11 :
                                  request[2] ? 2'b10 :
                                  request[1] ? 2'b01 :
                                  request[0] ? 2'b00 : current_channel;
                acknowledge <= 4'b0000;
                acknowledge[current_channel] <= 1'b1;
            end
        end
    end
endmodule