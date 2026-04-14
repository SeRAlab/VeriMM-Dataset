module top_module(
    input clk50mhz,
    input reset,
    input ear,
    output reg spk,
    output reg mic,
    output reg video,
    output reg sync
);always @(posedge clk50mhz or negedge reset) begin
        if (!reset) begin
            spk <= 0;
            mic <= 0;
            video <= 0;
            sync <= 0;
        end else begin
            if (ear) begin
                spk <= ear;
                mic <= 0;
            end else begin
                mic <= ear;
                spk <= 0;
            end
            // Change to toggle video every clock cycle
            video <= ~video;

            // Toggle sync based on only one clock edge
            if (clk50mhz) begin
                sync <= ~sync;
            end
        end
    end

endmodule