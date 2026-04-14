module clock_gating_flip_flop (
    input wire clk,        // original clock
    input wire enable,     // clock gating enable signal
    input wire d,         // data input
    output reg q          // output from flip-flop
);
    wire gated_clk;

    // Clock gating logic
    assign gated_clk = clk & enable;

    // Flip-Flop with gated clock
    always @(posedge gated_clk) begin
        q <= d;
    end
endmodule