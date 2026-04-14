module top_module(
    input clk,
    input rst,
    input ctrl,
    output reg [1:0] out
);always @ (posedge clk) begin
    if (rst) begin
        out <= 2'b00;
    end else begin
        if (ctrl) begin
            out <= (out == 2'b11) ? 2'b00 : out + 1;
        end else begin
            out <= (out == 2'b00) ? 2'b11 : out - 1;
        end
    end
end

endmodule