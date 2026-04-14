module dma_controller (
    input wire clk,
    input wire [3:0] req,  // Request signals from 4 channels
    output reg [3:0] gnt   // Grant signals to the channels
);

    always @(posedge clk) begin
        gnt <= 4'b0000; // Default no grant
        if (req[0]) gnt <= 4'b0001; // Grant to Channel 0
        else if (req[1]) gnt <= 4'b0010; // Grant to Channel 1
        else if (req[2]) gnt <= 4'b0100; // Grant to Channel 2
        else if (req[3]) gnt <= 4'b1000; // Grant to Channel 3
    end
endmodule