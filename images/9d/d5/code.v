module top_module(
    input clk,
    input d,
    input sr,
    output reg q,
    output reg qn
);always @(posedge clk or negedge sr)
begin
    if (~sr)
        q <= 0;
    else
        q <= d;
end

always @(posedge clk or negedge sr)
begin
    if (~sr)
        qn <= 1;
    else
        qn <= ~d;
end

endmodule