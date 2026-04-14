module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input load,
    input [1:0] ena,
    input [15:0] in,
    input select,
    output [15:0] q
);reg [99:0] shift_reg;
    reg [15:0] adder_out;
    reg [15:0] shift_out;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 100'b0;
            adder_out <= 16'b0;
            shift_out <= 16'b0;
        end else begin
            if (load) begin
                shift_reg <= in;
            end else begin
                if (ena == 2'b00) begin
                    shift_reg <= {shift_reg[98:0], shift_reg[99]};
                end else if (ena == 2'b01) begin
                    shift_reg <= {shift_reg[0], shift_reg[99:1]};
                end
            end
            if (select) begin
                adder_out <= in + 16'b0000000000010000;
            end else begin
                shift_out <= shift_reg[99:84];
            end
        end
    end

    assign q = select ? adder_out : shift_out;

endmodule