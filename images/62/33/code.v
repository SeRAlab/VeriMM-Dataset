module top_module(
    input clk,
    input reset,
    input set,
    input [2:0] data,
    output reg q
);always @(posedge clk or posedge reset or posedge set) begin
    if (reset) begin
        q <= 1'b0;
    end else if (set) begin
        q <= 1'b1;
    end else begin
        q <= data[2] & data[1] & data[0];
    end
end

endmodule