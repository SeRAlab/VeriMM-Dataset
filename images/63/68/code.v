module top_module(
    input clk,        // Added clk input
    input SHIFT,
    input DATA_IN,
    output reg SHIFT_OUT,
    output reg [31:0] DATA_OUT
);reg [31:0] pipeline [0:2];

always @(posedge clk) begin
    // Store DATA_IN into the first pipeline stage
    pipeline[0] <= {pipeline[0][30:0], DATA_IN};
    pipeline[1] <= pipeline[0];
    pipeline[2] <= pipeline[1];
end

assign DATA_OUT = pipeline[2];

always @(posedge clk) begin
    if (SHIFT) begin
        SHIFT_OUT <= pipeline[0][31]; // Assign SHIFT_OUT on SHIFT
        // Shift the pipeline stages
        pipeline[0] <= {pipeline[0][30:0], pipeline[1][31]};
        pipeline[1] <= {pipeline[1][30:0], pipeline[2][31]};
        pipeline[2] <= {pipeline[2][30:0], 1'b0}; // Fill LSB with 0
    end else begin
        SHIFT_OUT <= 1'b0; // Clear SHIFT_OUT when not shifting
    end
end

endmodule