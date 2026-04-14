module top_module(clk, reset, set, d, q, qn);input clk, reset, set, d;
output q, qn;
reg q, qn;

always @(posedge clk or negedge reset or negedge set) begin
    if (!reset) begin
        q <= 0;
        qn <= 1;
    end else if (!set) begin
        q <= 1;
        qn <= 0;
    end else begin
        q <= d;
        qn <= ~d;
    end
end

endmodule