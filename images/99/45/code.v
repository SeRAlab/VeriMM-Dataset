module top_module(clk, reset, d, q, qn);input clk;
input reset;
input d;
output q;
output qn;

reg q;
reg qn;

always @(posedge clk, posedge reset) begin
    if (reset) begin
        q <= 1'b0;
        qn <= 1'b1;
    end else begin
        q <= d;
        qn <= ~d;
    end
end

endmodule