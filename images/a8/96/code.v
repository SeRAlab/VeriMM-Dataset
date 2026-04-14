module top_module(
    input clk,
    input reset,
    input load,
    input direction,
    input [3:0] data_in,
    output reg [3:0] count
);always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0;
        end else if (load) begin
            count <= data_in;
        end else if (direction) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end

endmodule