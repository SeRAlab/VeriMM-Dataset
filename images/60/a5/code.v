module top_module(
    input A,
    input load,
    input clk,
    output reg Q2,
    output reg Q1,
    output reg Q0
);always @(posedge clk) begin
        if (load) begin
            Q2 <= A;
            Q1 <= A;
            Q0 <= A;
        end
        else begin
            Q2 <= Q1;
            Q1 <= Q0;
            Q0 <= A;
        end
    end

endmodule