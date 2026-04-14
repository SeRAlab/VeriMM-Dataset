module top_module(
    input [7:0] a,
    input [7:0] b,
    input ctrl,
    output reg [15:0] c
);always @(*) begin
        if (ctrl == 1) begin // signed multiplication
            c = $signed(a) * $signed(b);
        end else begin // unsigned multiplication
            c = a * b;
        end
    end

endmodule