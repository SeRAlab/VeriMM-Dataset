module top_module(
    input clk,
    input clr,
    input d,
    output reg q
);reg [2:0] dff;
wire [2:0] q_wire;

always @(posedge clk, negedge clr) begin
    if (~clr) begin
        dff <= 3'b111;
    end else begin
        dff <= {dff[1:0], d};
    end
end

assign q_wire = {dff[2], dff[1], dff[0]};
assign q = q_wire[2];

endmodule