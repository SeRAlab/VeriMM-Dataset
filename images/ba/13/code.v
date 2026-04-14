module top_module(
    input clk,
    input reset,
    input load,
    input [11:0] data,
    input ena,
    output reg [11:0] q);

    always @(posedge clk or posedge reset or posedge load) begin
        if (reset) begin
            q <= 12'b0;
        end else if (load) begin
            q <= data;
        end else if (ena) begin
            q <= q + 1;
        end
    end

endmodule