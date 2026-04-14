module vco (
    input wire clk,
    input wire control,
    output reg out_clk
);
    reg [1:0] toggle;

    always @(posedge clk) begin
        if (control) begin
            toggle <= toggle + 2'b01; // Increment toggle for frequency doubling
        end else begin
            toggle <= 2'b00; // Reset toggle
        end
    end

    always @(posedge clk) begin
        if (control) begin
            out_clk <= ~out_clk; // Toggle output clock for frequency doubling
        end else begin
            out_clk <= out_clk; // Keep output clock steady
        end
    end
endmodule