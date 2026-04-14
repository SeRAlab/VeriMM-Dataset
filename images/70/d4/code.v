module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);reg [99:0] shift_reg;
reg [4:0] shift_amt;
wire [99:0] rotated_out;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data;
        shift_amt <= 0;
    end else if (ena[0]) begin
        shift_reg <= {shift_reg[98:0], shift_reg[99]}; // Rotate right
        shift_amt <= shift_amt + 1;
    end else if (ena[1]) begin
        shift_reg <= {shift_reg[0], shift_reg[99:1]}; // Rotate left (fixed order)
        shift_amt <= shift_amt - 1;
    end
end

assign rotated_out = (shift_amt[4]) ? {shift_reg[0], shift_reg[99:1]} : {shift_reg[98:0], shift_reg[99]};

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena[0] || ena[1]) begin
        q <= rotated_out;
    end
end

endmodule