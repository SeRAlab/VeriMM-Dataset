module top_module(
    input rst,
    input clk,
    output out
);reg out_r;
    assign out = out_r;
    always @(posedge clk) begin
        out_r <= ~out_r && (~rst);
    end
endmodule