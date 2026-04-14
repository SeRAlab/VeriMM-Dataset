module top_module(
    input clk,
    input reset,
    input load,
    input [1:0] ena,
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor,
    output reg [99:0] q
);// BDD-based AND/OR/XOR circuit
wire and_out;
wire or_out;
wire xor_out;

assign and_out = &in;
assign or_out = |in;
assign xor_out = ^in;

// Barrel shifter-based rotator
reg [99:0] rot_q;
always @(posedge clk) begin
    if (reset) begin
        rot_q <= 100'b0;
    end else if (load) begin
        rot_q <= in;
    end else if (ena[0]) begin
        rot_q <= {rot_q[98:0], rot_q[99]}; // Rotate right
    end else if (ena[1]) begin
        rot_q <= {rot_q[0], rot_q[99:1]}; // Rotate left
    end
end

// Bitwise AND of circuit output and rotator output
assign out_and = and_out & rot_q;

// Output circuit results
assign out_or = or_out;
assign out_xor = xor_out;

// Output rotator results
always @(posedge clk) begin
    if (reset) begin
        q <= 100'b0;
    end else begin
        q <= rot_q;
    end
end

endmodule