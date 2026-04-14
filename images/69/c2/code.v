module top_module(
    input clk,
    input reset,
    input [7:0] in,
    output [7:0] toggled,
    output [7:0] count,
    output [7:0] final_output
);reg [7:0] toggled_reg;
reg [7:0] count_reg;
reg [7:0] final_output_reg;

wire [7:0] toggled_wire;
wire [7:0] count_wire;

// Toggling circuit
reg [7:0] dff_in;
reg [7:0] dff_out;
wire [7:0] xor_out;

always @(posedge clk) begin
    dff_in <= in;
    dff_out <= dff_in ^ toggled_reg;
end

assign toggled_wire = xor_out;
assign toggled = toggled_reg;

// Population count circuit
wire [3:0] count_0;
wire [3:0] count_1;
wire [3:0] count_2;
wire [3:0] count_3;

assign count_0 = in[0] + in[4];
assign count_1 = in[1] + in[5];
assign count_2 = in[2] + in[6];
assign count_3 = in[3] + in[7];

wire [3:0] count_01;
wire [3:0] count_23;

assign count_01 = count_0 + count_1;
assign count_23 = count_2 + count_3;

assign count_wire = count_01 + count_23;
assign count = count_reg;

// Final functional module
always @(posedge clk) begin
    toggled_reg <= dff_out;
    count_reg <= count_wire;
    final_output_reg <= toggled_reg + count_reg;
end

assign final_output = final_output_reg;

endmodule