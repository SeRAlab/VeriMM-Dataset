module dma_controller(
    input wire clk,
    input wire reset,
    input wire EN,
    input wire [3:0] REQ,
    output reg [3:0] GNT
);

    reg [1:0] current_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            GNT <= 4'b0000;
            current_channel <= 2'b00;
        end else if (EN) begin
            if (REQ != 4'b0000) begin
                GNT <= 4'b0000; // Clear all grants
                GNT[current_channel] <= 1; // Grant to current channel
                
                // Move to the next channel for round-robin
                current_channel <= (current_channel + 1) % 4;
            end else begin
                GNT <= 4'b0000; // No requests, clear grant
            end
        end
    end
endmodule