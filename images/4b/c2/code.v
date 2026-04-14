module top_module(
    input clk,
    input reset,
    input [99:0] in,
    input select,
    input load,
    input [1:0] ena,
    output reg [99:0] q
);// NOR gate-based combinational circuit from problem 1
wire [3:0] nor_out;
assign nor_out = ~(in[0] | in[1]) & ~(in[2] | in[3]);

// Shift register-based 100-bit rotator from problem 2
reg [99:0] shift_reg;
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 0;
    end else if (load) begin
        shift_reg <= in;
    end else if (ena[0]) begin
        if (select) begin
            shift_reg <= {shift_reg[0], shift_reg[99:1]};
        end else begin
            shift_reg <= {shift_reg[98:0], shift_reg[99]};
        end
    end
end

// 2's complement addition module
wire [99:0] add_out;
reg [99:0] neg_shift_reg;
assign neg_shift_reg = ~shift_reg + 1;
always @(posedge clk) begin
    if (reset) begin
        q <= 0;
    end else if (ena[1]) begin
        if (select) begin
            q <= nor_out + neg_shift_reg;
        end else begin
            q <= nor_out + shift_reg;
        end
    end
end

endmodule