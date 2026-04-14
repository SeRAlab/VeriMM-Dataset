module top_module(
    input clk,
    input reset,
    input [3:0] data_in,
    output reg out
);reg [7:0] shift_reg;
wire [3:0] mux_in;
reg [1:0] mux_sel;

assign mux_in = shift_reg[7:4];

always @ (posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
        mux_sel <= 2'b0;
    end else begin
        shift_reg <= {shift_reg[6:0], data_in};
        mux_sel <= shift_reg[1:0];
    end
end

always @ (*) begin
    case (mux_sel)
        2'b00: out = mux_in[0];
        2'b01: out = mux_in[1];
        2'b10: out = mux_in[2];
        2'b11: out = mux_in[3];
    endcase
end

endmodule