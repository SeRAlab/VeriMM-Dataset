module deadbeat_controller (
    input clk,
    input [2:0] x_in,
    output reg [2:0] y_out
);
    always @(posedge clk) begin
        y_out <= x_in;
    end
endmodule