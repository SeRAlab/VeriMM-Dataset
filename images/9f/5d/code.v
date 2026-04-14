module top_module( clk, d, q );input clk;
    input d;
    output q;
    reg q1, q2, q3;
    reg c_q1, c_q2, c_q3;
    always @ (posedge clk) begin
        q1 <= d;
        c_q1 <= q1;
        c_q2 <= c_q1;
        c_q3 <= c_q2;
    end
    assign q = c_q3;
endmodule