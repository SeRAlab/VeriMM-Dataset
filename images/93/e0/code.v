module top_module(
    input clk,
    input reset,
    input [3:0] a,
    input [3:0] b,
    input select,
    output reg [4:0] sum // Changed from wire to reg
);// Instantiate two 4-bit adders with active high synchronous reset
    reg [3:0] adder1_out, adder2_out;
    always @(posedge clk) begin
        if (reset) begin
            adder1_out <= 4'b0;
            adder2_out <= 4'b0;
        end else begin
            adder1_out <= a + b;
            adder2_out <= a + b;
        end
    end

    // Instantiate a functional module that adds the two inputs together to produce a 5-bit output
    reg [4:0] func_out;
    always @(*) begin
        func_out = {1'b0, a + b};
    end

    // Instantiate a multiplexer that selects between the outputs of the two adders or the output of the functional module based on the select input
    always @(*) begin
        case (select)
            1'b0: sum = adder1_out;  // Change to 1-bit selection for select
            1'b1: sum = adder2_out;  // Change to 1-bit selection for select
            2'b10: sum = func_out;
            2'b11: sum = func_out;
            default: sum = 5'b0; // Default case to avoid latches
        endcase
    end

endmodule