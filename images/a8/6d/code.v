module top_module(
    input in,
    input ctrl,
    input reset,
    output reg out
);always @(posedge ctrl or posedge reset) begin
        if (reset) begin
            out <= 1'b0;
        end else begin
            if (ctrl) begin
                out <= in ^ ctrl;
            end else begin
                out <= in;
            end
        end
    end

endmodule