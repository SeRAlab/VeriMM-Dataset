module top_module(
    input clk,
    input reset,
    input enable,
    output reg [2:0] q,
    output reg carry_out
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b000;
            carry_out <= 1'b0;
        end else if (enable) begin
            if (q == 3'b111) begin
                q <= 3'b000;
                carry_out <= 1'b1;
            end else begin
                q <= q + 1;
                carry_out <= 1'b0;
            end
        end
    end

endmodule