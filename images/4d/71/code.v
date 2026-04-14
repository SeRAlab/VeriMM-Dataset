module top_module(
    input clk,
    input reset,
    input [15:0] DATA_IN,
    input LOAD,
    input [15:0] a,
    input [15:0] b,
    output [15:0] DATA_OUT,
    output eq,
    output greater_eq
);reg [15:0] shift_reg;
reg [15:0] shift_reg_out;
wire [15:0] shift_reg_next;
wire [15:0] a_reg;
wire [15:0] b_reg;

assign shift_reg_next = {DATA_IN, shift_reg[15:1]};
assign a_reg = (LOAD) ? DATA_IN : a;
assign b_reg = (LOAD) ? DATA_IN : b;
assign eq = (a_reg == b_reg);

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 16'h0000;
        shift_reg_out <= 16'h0000;
    end else begin
        shift_reg <= shift_reg_next;
        shift_reg_out <= shift_reg[0];
    end
end

assign DATA_OUT = shift_reg_out;

assign greater_eq = (shift_reg_out >= b_reg);

endmodule