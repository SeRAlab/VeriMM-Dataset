module top_module(
    input [15:0] in,
    input [15:0] mask,
    input enable,
    output reg [15:0] out
);always @(*) begin
    if(enable) begin
        out = in & mask;
    end else begin
        out = 16'b0;
    end
end

endmodule