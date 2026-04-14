module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    input a,
    input b,
    output out
);reg [99:0] shift_reg;
wire [99:0] shifted_data;

// Shift register module
always @(posedge clk) begin
    if (load) begin
        shift_reg <= data;
    end else if (ena == 2'b01) begin
        shift_reg <= {shift_reg[0], shift_reg[99:1]};
    end else if (ena == 2'b10) begin
        shift_reg <= {shift_reg[98:0], shift_reg[99]};
    end
end

assign shifted_data = shift_reg;

// NOR gate module
assign out = ~(a | b);

endmodule