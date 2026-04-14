module top_module(
    input clk,
    input [7:0] load,
    input reset,
    output reg [7:0] out
);always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0;
        end else if (load) begin
            out <= load;
        end else begin
            out <= {out[6:0], 1'b0};
        end
    end

endmodule