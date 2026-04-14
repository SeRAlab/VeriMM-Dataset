module top_module(
    input [2:0] a,
    input [2:0] b,
    input clk,
    input reset,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not,
    output [99:0] final_output
);// Bitwise-OR and Logical-OR circuit
wire [2:0] bitwise_or;
wire logical_or;

assign bitwise_or = a | b;
assign logical_or = (a != 0) || (b != 0);

// NOT circuit
wire [2:0] not_b;
wire [2:0] not_a;

assign not_b = ~b;
assign not_a = ~a;

// Rotation circuit
reg [99:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 0;
    end else if (load) begin
        shift_reg <= data;
    end else if (ena == 2'b01) begin
        shift_reg <= {shift_reg[0], shift_reg[99:1]};
    end else if (ena == 2'b10) begin
        shift_reg <= {shift_reg[98:0], shift_reg[99]};
    end
end

// Final output circuit
wire [99:0] rotated_output;

assign rotated_output = (ena == 2'b00 || ena == 2'b11) ? shift_reg : ((ena == 2'b01) ? {shift_reg[0], shift_reg[99:1]} : {shift_reg[98:0], shift_reg[99]});

assign final_output = {rotated_output[99:1], bitwise_or[2], rotated_output[98:0], bitwise_or[1:0], logical_or};

assign out_or_bitwise = bitwise_or;
assign out_or_logical = logical_or;
assign out_not = {not_b[2:0], not_a[2:0]};

endmodule