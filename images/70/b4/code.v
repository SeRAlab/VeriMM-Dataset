module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] d1,   // 8-bit input for the first register
    input [7:0] d2,   // 8-bit input for the second register
    output [7:0] q    // 8-bit output from the functional module
);reg [7:0] reg1, reg2;
    wire [7:0] diff;

    // Registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            reg1 <= 8'd0;
            reg2 <= 8'd0;
        end else begin
            reg1 <= d1;
            reg2 <= d2;
        end
    end

    // Difference calculator
    assign diff = reg1 - reg2;

    // Output
    assign q = diff;

endmodule