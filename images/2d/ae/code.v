module reset_controller (
    input wire clk,
    input wire reset_in,
    input wire reset_enable,
    output reg reset_out
);
    always @(posedge clk) begin
        if (reset_in || reset_enable) begin
            reset_out <= 1'b1;
        end else begin
            reset_out <= 1'b0;
        end
    end
endmodule