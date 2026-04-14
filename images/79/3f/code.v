module top_module(
    input wire A0,
    input wire A1,
    input wire S,
    output reg X
);always @(*) begin
    if (S == 1'b0) begin
        X = A0;
    end else begin
        X = A1;
    end
end

endmodule