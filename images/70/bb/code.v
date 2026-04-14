module top_module(
    input wire clk,
    input wire reset,
    input wire Q,
    output reg dff_output
);always @ (negedge clk or posedge reset) begin
        if (reset) begin
            dff_output <= 1'b0;
        end else begin
            dff_output <= Q;
        end
    end

endmodule