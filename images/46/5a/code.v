module top_module(clk, rst, set, d, q, qn);input clk, rst, set, d;
output q, qn;
reg q;

always @(posedge clk or negedge rst or negedge set) begin
    if (~rst) begin
        q <= 1'b0;
    end else if (~set) begin
        q <= 1'b1;
    end else begin
        q <= d;
    end
end

assign qn = ~q;

endmodule