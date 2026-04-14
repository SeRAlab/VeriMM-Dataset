module top_module( 
    input clk,
    input [2:0] a,
    input [2:0] b,
    input d,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not,
    output q
);// Logical Operations Module
wire [2:0] bitwise_or;
wire logical_or;
wire [2:0] a_not;
wire [2:0] b_not;

assign bitwise_or = a | b;
assign logical_or = (a != 0) || (b != 0);
assign a_not = ~a;
assign b_not = ~b;

assign out_or_bitwise = bitwise_or;
assign out_or_logical = logical_or;
assign out_not = {b_not, a_not};

// Shift Register
reg [2:0] shift_reg [0:2];
wire [2:0] q_reg;

always @(posedge clk) begin
    shift_reg[0] <= d;
    shift_reg[1] <= shift_reg[0];
    shift_reg[2] <= shift_reg[1];
end

assign q_reg = shift_reg[2];

// Functional Module
wire [2:0] final_output;

assign final_output = out_or_bitwise | q_reg;

assign q = final_output;

endmodule