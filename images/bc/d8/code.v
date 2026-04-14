module top_module(
    input CLK,
    input reset,
    input [3:0] in1,
    input [3:0] in2,
    output reg [3:0] out
);always @(posedge CLK) begin
        if (reset) begin
            out <= 4'd0;
        end else begin
            out <= in1 + in2;
        end
    end

endmodule