module top_module(
    input [15:0] in0,
    input [15:0] in1,
    input ctrl,
    output reg [15:0] out
);always @(*) begin
    if (ctrl == 0) begin
        out = in0 + in1;
    end else begin
        out = in0 - in1;
    end
end

endmodule