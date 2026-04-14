module top_module(
    input clk,
    input [15:0] din,
    input [3:0] ctrl,
    output reg [15:0] dout     // Change output to reg type
);always @(posedge clk) begin
        case(ctrl)
            4'b0000: dout <= din;
            4'b0001: dout <= din & 16'h00FF;
            4'b0010: dout <= din | 16'hFF00;
            4'b0011: dout <= din ^ 16'hFFFF;
            default: dout <= 16'h0000;
        endcase
    end

endmodule