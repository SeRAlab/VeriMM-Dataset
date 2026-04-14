module top_module(
    input clk,
    input dir,
    input [2:0] in,
    output reg [2:0] out
);always @(posedge clk) begin
        if (dir == 1'b0) // shift right
            out <= {in[0], out[2:1]};
        else // shift left
            out <= {out[1:0], in[2]}; // Corrected to {out[1:0], in[2]}
    end

endmodule