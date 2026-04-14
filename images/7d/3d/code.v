module top_module(
    input clk,
    input rst,
    input [3:0] shift_in,
    output reg [3:0] shift_out
);always @(posedge clk) begin
    if (rst) begin
        shift_out <= 4'b0000;
    end else begin
        shift_out <= {shift_out[2:0], shift_in};
    end
end

endmodule