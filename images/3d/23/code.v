module dma_controller (
    input clk,
    input rst,
    input [3:0] request,
    output reg [3:0] grant,
    output reg transfer_in_progress
);
    reg [1:0] current_channel;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
            transfer_in_progress <= 1'b0;
            current_channel <= 2'b00;
        end else begin
            if (request != 4'b0000 && !transfer_in_progress) begin
                // Grant the highest priority request
                if (request[0]) begin
                    grant <= 4'b0001;
                    current_channel <= 2'b00;
                end else if (request[1]) begin
                    grant <= 4'b0010;
                    current_channel <= 2'b01;
                end else if (request[2]) begin
                    grant <= 4'b0100;
                    current_channel <= 2'b10;
                end else if (request[3]) begin
                    grant <= 4'b1000;
                    current_channel <= 2'b11;
                end
                transfer_in_progress <= 1'b1;
            end else if (transfer_in_progress) begin
                // Simulate data transfer completion
                grant <= 4'b0000;
                transfer_in_progress <= 1'b0;
            end
        end
    end
endmodule