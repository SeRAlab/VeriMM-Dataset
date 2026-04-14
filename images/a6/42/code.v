module top_module(
    input [3:0] in,
    input shift_dir,
    input clk,
    output reg [3:0] out
);always @(posedge clk) begin
        if (shift_dir == 0) begin
            out <= {out[2:0], in};
        end else begin
            out <= {in, out[3:1]};
        end
    end

endmodule