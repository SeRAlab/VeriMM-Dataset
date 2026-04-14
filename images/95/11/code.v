module top_module(
    input clk,
    input load,
    input [3:0] data,
    output reg [3:0] out
);always @(posedge clk) begin
        if (load) begin
            out <= data;
        end else begin
            out <= {out[2:0], data[3]};
        end
    end

endmodule