module top_module(
    input clk,
    input rst,
    input set,
    input d,
    output reg q
);always @(posedge clk) begin
    if(rst) begin
        q <= 0;
    end else if(set) begin
        q <= 1;
    end else begin
        q <= d;
    end
end

endmodule