module top_module(
    input clk,
    input d,
    output reg q
);reg t;

always @(posedge clk) begin
    if (d) begin
        t <= ~t;
    end
end

assign q = t;

endmodule