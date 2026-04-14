module top_module(
    input clk,
    input load,
    input [7:0] data_in,
    input [1:0] in_0,
    input [1:0] in_1,
    output reg [7:0] data_out,  // Changed from wire to reg
    output reg [1:0] out
);reg [7:0] shift_reg;
wire [1:0] comp_out;

// Shift Register with Parallel Load
always @(posedge clk) begin
    if (load) begin
        shift_reg <= data_in;
    end else begin
        shift_reg <= {shift_reg[6:0], 1'b0};
    end
end

// 2-Bit Comparator
assign comp_out = (in_0 > in_1) ? 2'b01 : (in_0 < in_1) ? 2'b00 : 2'b10;

// Final Output
always @(*) begin
    case (comp_out)
        2'b10: data_out = shift_reg;
        2'b01: data_out = {out, shift_reg};
        2'b00: data_out = {out, shift_reg};
    endcase
end

endmodule