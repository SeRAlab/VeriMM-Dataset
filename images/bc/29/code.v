module top_module(clk, reset, d, q, qn);input clk, reset, d;
    output q, qn;
    reg q, qn;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            q <= 0;
            qn <= 1;
        end
        else begin
            q <= d;
            qn <= ~d;
        end
    end
endmodule