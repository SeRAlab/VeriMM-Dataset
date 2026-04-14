module top_module(clk, rst, set, d, q, qn);input clk, rst, set, d;
output q, qn;
reg q, qn;

always @(posedge clk or posedge rst or posedge set) begin
    if (rst) begin
        q <= 0;
        qn <= 1;
    end
    else if (set) begin
        q <= 1;
        qn <= 0;
    end
    else begin
        q <= d;
        qn <= ~d;
    end
end

endmodule