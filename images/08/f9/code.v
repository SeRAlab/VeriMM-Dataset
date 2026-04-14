module pll_4x (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);

reg [1:0] phase; // 00: aligned, 01: clk_in faster, 10: clk_out faster
reg [3:0] vco_count;

// Phase detector
always @(posedge clk_in or posedge reset) begin
    if (reset) begin
        phase <= 2'b00;
    end else begin
        if (vco_count == 4'b1111) begin
            phase <= 2'b00; // aligned
        end else if (vco_count < 4'b1111) begin
            phase <= 2'b01; // clk_in faster
        end else begin
            phase <= 2'b10; // clk_out faster
        end
    end
end

// Voltage-controlled oscillator (VCO)
always @(posedge clk_in or posedge reset) begin
    if (reset) begin
        vco_count <= 4'b0000;
    end else begin
        if (phase == 2'b00) begin
            vco_count <= vco_count + 1;
        end else if (phase == 2'b01) begin
            vco_count <= vco_count; // Keep VCO count
        end else if (phase == 2'b10) begin
            vco_count <= vco_count - 1; // Decrease VCO count
        end
    end
end

// Generating output clock
always @(posedge clk_in or posedge reset) begin
    if (reset) begin
        clk_out <= 0;
    end else begin
        if (vco_count >= 4'b1000) begin
            clk_out <= ~clk_out; // Toggle output clock
        end
    end
end

endmodule