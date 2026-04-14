module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] d,    // 8-bit input for the register
    output [7:0] q    // 8-bit output from the functional module
);reg [7:0] reg_out;
    reg [7:0] shift_reg_out;
    wire [7:0] adder_out;

    // Register module with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            reg_out <= 8'h34;
        end else begin
            reg_out <= d;
        end
    end

    // Shift register module
    always @(posedge clk or negedge reset) begin
        if (reset) begin
            shift_reg_out <= 8'h00;
        end else begin
            shift_reg_out <= {shift_reg_out[6:0], d};
        end
    end

    // Adder module
    assign adder_out = reg_out - shift_reg_out;

    // Output
    assign q = adder_out;

endmodule