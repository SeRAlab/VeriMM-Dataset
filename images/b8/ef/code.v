module top_module(
    input clk,
    input serial_in,
    input in1,
    input in2,
    output [2:0] shift_out,
    output out
);// 2:1 Multiplexer
    wire mux_out;
    assign mux_out = in1 ? in1 : in2;

    // 3-bit Shift Register
    reg [2:0] shift_reg;
    always @(posedge clk) begin
        shift_reg <= {shift_reg[1:0], mux_out};
    end

    // Final Output
    assign out = shift_reg[2] | shift_out[2];

    // Output of Shift Register
    assign shift_out = shift_reg;

endmodule