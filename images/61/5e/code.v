module top_module(
    input clk,
    input reset,
    input a,
    input b,
    input sel_b1,
    output reg [6:0] prbs
);reg [6:0] prbs_reg;
wire mux_out;
reg mux_sel;

assign mux_out = sel_b1 ? b : a;

always @(posedge clk, negedge reset) begin
    if (!reset) begin
        prbs_reg <= 7'b0000000;
        mux_sel <= 1'b0;
    end else begin
        prbs_reg <= {prbs_reg[5:0], prbs_reg[6] ^ mux_out ^ prbs_reg[0]};
        mux_sel <= ~mux_sel;
    end
end

always @(posedge clk, negedge reset) begin
    if (!reset) begin
        prbs <= 7'b0000000;
    end else begin
        prbs <= {prbs_reg[6], prbs_reg[5] ^ prbs_reg[6], prbs_reg[4] ^ prbs_reg[6], prbs_reg[3] ^ prbs_reg[6], prbs_reg[2] ^ prbs_reg[6], prbs_reg[1] ^ prbs_reg[6], prbs_reg[0] ^ prbs_reg[6]};
    end
end

endmodule