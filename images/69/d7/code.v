module top_module(
    input clk,
    input [7:0] d,
    input a,
    input [7:0] b,
    output reg [7:0] q
);reg [7:0] sum;
    reg [7:0] shift_reg;

    always @ (posedge clk) begin
        // 8-bit adder
        sum <= d + b;

        // 8-bit shift register
        shift_reg <= {shift_reg[6:0], d[0]};
    end

    // 2-to-1 MUX
    always @ (*) begin
        if (a == 1'b1) begin
            q <= shift_reg;
        end else begin
            q <= sum;
        end
    end

endmodule