module top_module(
    input wire I0,
    input wire I1,
    input wire S,
    output reg O
);always @(*) begin
    if (S) begin
        O = I1;
    end else begin
        O = I0;
    end
end

endmodule