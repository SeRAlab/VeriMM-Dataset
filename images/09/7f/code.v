module dma_controller (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg grant,
    output reg [1:0] active_channel
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 0;
            active_channel <= 2'b00;
        end else begin
            if (req0) begin
                grant <= 1;
                active_channel <= 2'b00;
            end else if (req1) begin
                grant <= 1;
                active_channel <= 2'b01;
            end else if (req2) begin
                grant <= 1;
                active_channel <= 2'b10;
            end else if (req3) begin
                grant <= 1;
                active_channel <= 2'b11;
            end else begin
                grant <= 0;
                active_channel <= 2'b00; // No active channel
            end
        end
    end
endmodule