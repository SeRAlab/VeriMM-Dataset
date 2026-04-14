module top_module(
    input clk,
    input [99:0] a, b,
    input cin,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output cout,
    output reg [99:0] q
);// 100-bit binary adder
wire [99:0] sum;
wire [99:0] carry_out;
assign {carry_out, sum} = a + b + cin;

// 100-bit left/right rotator
wire [99:0] rotated_data;
reg [99:0] shift_reg;
always @(posedge clk) begin
    if (load) begin
        shift_reg <= data;
    end else begin
        case (ena)
            2'b00: shift_reg <= {shift_reg[98:0], shift_reg[99]};
            2'b01: shift_reg <= {shift_reg[99], shift_reg[98:0]};
            2'b10: shift_reg <= shift_reg;
            2'b11: shift_reg <= shift_reg;
        endcase
    end
end
assign rotated_data = shift_reg;

// Bitwise OR operation
wire [99:0] final_output;
assign final_output = sum | rotated_data;

// Output signals
assign cout = carry_out[99];
always @(posedge clk) begin
    q <= final_output;
end

endmodule