module top_module(
    input clk,
    input load,
    input shift,
    input [11:0] data,
    output reg [11:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (shift) begin
            q <= q << 1;
        end
    end

endmodule