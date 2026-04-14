module top_module(
    input clk,
    input reset,
    input [99:0] data,
    input [1:0] ena,
    input load,
    input A, B, SEL,
    output reg [99:0] q);reg [99:0] reg_data;
    wire [99:0] shifted_data;

    // 2:1 Multiplexer
    assign shifted_data = SEL ? reg_data << ena[1:0] : reg_data >> ena[1:0];
    assign q = SEL ? B : A;

    // Barrel Shifter
    always @(posedge clk) begin
        if (reset) begin
            reg_data <= 0;
        end else if (load) begin
            reg_data <= data;
        end else if (ena != 2'b00 && ena != 2'b11) begin
            reg_data <= shifted_data;
        end
    end

endmodule