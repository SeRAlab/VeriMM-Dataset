module top_module(
    input clk,
    input reset,
    output reg [3:0] count,
    output reg out
);always @(posedge clk) begin
    if(reset) begin
        count <= 4'b0;
        out <= 1'b0;
    end
    else begin
        count <= count + 1;
        out <= ~out;
    end
end

endmodule