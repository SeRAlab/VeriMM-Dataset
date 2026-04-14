module top_module(
    input clk,
    input reset,
    input shift_in,
    input shift,
    output reg shift_out,
    output reg [3:0] q
);always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0;
            shift_out <= 1'b0;
        end else begin
            if (shift) begin
                shift_out <= q[0];
                q <= {shift_out, q[3:1]};
            end else begin
                shift_out <= q[3];
                q <= {q[2:0], shift_out};
            end
            q[0] <= shift_in;
        end
    end

endmodule