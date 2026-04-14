module top_module(
    input clk,          // Clock input
    input d,            // Input for shift register
    input [3:0] in,     // Input for combinational circuit
    output out_and,     // 2-level AND-OR circuit output
    output out_or,      // 2-level OR-AND circuit output
    output out_xor,     // 2-level XOR-AND circuit output
    output [7:0] sum    // Sum of shift register and combinational circuit outputs
);reg [2:0] shift_reg;
wire q;

// Shift register
always @(posedge clk) begin
    shift_reg <= {shift_reg[1:0], d};
end

assign q = shift_reg[2];

// Combinational circuit
wire and1 = in[0] & in[1];
wire and2 = in[2] & in[3];
wire or1 = in[0] | in[1];
wire or2 = in[2] | in[3];
wire xor1 = in[0] ^ in[1];
wire xor2 = in[2] ^ in[3];

assign out_and = and1 | and2;
assign out_or = or1 & or2;
assign out_xor = xor1 & xor2;

// Sum module
wire [7:0] shift_sum = {1'b0, shift_reg};
wire [7:0] comb_sum = {1'b0, out_and, out_or, out_xor};

assign sum = shift_sum + comb_sum;

endmodule