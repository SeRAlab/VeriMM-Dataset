module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);always @(posedge clk or negedge reset) begin
    if(reset == 0) begin
        q <= 4'b0000;
    end else if(q == 4'b1111) begin
        q <= 4'b0000;
    end else begin
        q <= q + 1;
    end
end

endmodule