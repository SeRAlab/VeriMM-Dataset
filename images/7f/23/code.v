module top_module(clk, d, rst, q, qn);input clk, d, rst;
    output q, qn;
    reg q, qn;

    always @(posedge clk) begin
        if (rst) begin
            q <= 1'b0;
            qn <= 1'b1;
        end else begin
            q <= d;
            qn <= ~d;
        end
    end
endmodule