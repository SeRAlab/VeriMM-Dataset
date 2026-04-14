module top_module(
    input clk,
    input load,
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);reg [7:0] shift_reg;
    wire [15:0] adder_input;
    wire [15:0] adder_output;

    // Shift register with parallel load
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= a[7:0];
        end else begin
            shift_reg <= {shift_reg[6:0], shift_reg[7]};
        end
    end

    // Adder module
    assign adder_input = {shift_reg, b};
    assign adder_output = sub ? {16{1'b0}} - adder_input : adder_input;

    // Output sum
    assign sum = adder_output[31:0];

endmodule