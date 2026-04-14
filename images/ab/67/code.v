module top_module(
    input clk,
    input rst,
    input en,
    input [1:0] sel,
    output reg [3:0] out
);always @(posedge clk or negedge rst) begin
        if (~rst) begin
            out <= 4'b0000;
        end else if (en) begin
            case (sel)
                2'b00: out <= out[0] ? {out[3:1], 1'b0} : {out[3:1], 1'b1};
                2'b01: out <= out[1] ? {out[3:2], out[0], 1'b0} : {out[3:2], out[0], 1'b1};
                2'b10: out <= out[2] ? {out[3], out[1:0], 1'b0} : {out[3], out[1:0], 1'b1};
                2'b11: out <= out[3] ? {1'b0, out[2:0]} : {1'b1, out[2:0]};
            endcase
        end
    end

endmodule