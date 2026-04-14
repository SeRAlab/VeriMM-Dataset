module top_module(
    input clk,
    input [7:0] d1,
    input [7:0] d2,
    input sel,
    input reset,
    output reg [7:0] q
);reg [7:0] flip_flop_out;
    wire [7:0] multiplier_out;

    // 2-to-1 multiplexer
    assign multiplier_out = (sel == 1'b0) ? 8'b0 : d2;

    // 8 D flip-flops
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            flip_flop_out <= 8'b0;
        end else begin
            flip_flop_out <= (sel == 1'b0) ? d1 : multiplier_out;
        end
    end

    // 8-bit multiplier
    assign q = flip_flop_out;

    //
endmodule