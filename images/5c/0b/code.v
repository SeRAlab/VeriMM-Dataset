module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q);reg [99:0] shift_reg;
    wire [99:0] mux_out;

    // Shift register
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data;
        end else begin
            if (ena[0]) begin
                shift_reg <= {shift_reg[98:0], shift_reg[99]};
            end else if (ena[1]) begin
                shift_reg <= {shift_reg[0], shift_reg[99:1]};
            end
        end
    end

    // Multiplexer
    assign mux_out = (ena[0]) ? {shift_reg[98:0], shift_reg[99]} :
                     (ena[1]) ? {shift_reg[0], shift_reg[99:1]} :
                                shift_reg;

    // Output
    always @(posedge clk) begin
        q <= mux_out;
    end

endmodule