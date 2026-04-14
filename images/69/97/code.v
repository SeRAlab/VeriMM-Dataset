module top_module(
    input clk,
    input rst_n,
    input [3:0] in,
    input [1:0] sel,
    input a,
    output reg rise,
    output reg down,
    output reg out
);reg a_prev;
reg a_edge;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        a_prev <= 1'b0;
        a_edge <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
        out <= 1'b0;
    end else begin
        a_prev <= a;
        a_edge <= a ^ a_prev;
        rise <= a_edge & a;
        down <= a_edge & ~a;
        case (sel)
            2'b00: out <= {in[0], rise, down};
            2'b01: out <= {in[1], rise, down};
            2'b10: out <= {in[2], rise, down};
            2'b11: out <= {in[3], rise, down};
        endcase
    end
end

endmodule