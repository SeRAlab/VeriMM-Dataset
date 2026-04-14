module top_module(
    input clk,
    input rst,
    input [99:0] in,
    output [99:0] out
);reg [4:0] shift_reg;
reg [99:0] shifted_output;

// Shift Register
always @(posedge clk, posedge rst) begin
    if (rst) begin
        shift_reg <= 5'b0;
    end else begin
        shift_reg <= {shift_reg[3:0], in[99]};
    end
end

// Barrel Shifter
always @(posedge clk, posedge rst) begin
    if (rst) begin
        shifted_output <= 100'b0;
    end else begin
        shifted_output <= {shift_reg, in[94:0]};
    end
end

// Output
assign out = shifted_output;

endmodule