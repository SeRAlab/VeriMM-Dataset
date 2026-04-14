module top_module(
    input clk,
    input reset,
    output reg [9:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'b0000000001;
        end else begin
            q <= {q[8:0], ~q[9]};
        end
    end

endmodule