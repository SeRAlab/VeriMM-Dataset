module shift_reg_nor (
    input clk,
    input reset,
    input a,
    input b,
    input d,
    output out
);

    reg [2:0] shift_reg;
    wire nor_out;

    // Shift register
    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            shift_reg <= 3'b0;
        end else begin
            shift_reg <= {shift_reg[1:0], d};
        end
    end

    // NOR gate
    nand n1 (nor_out, a, b);
    nand n2 (nor_out, nor_out, nor_out);

    // Output
    assign out = ~nor_out | shift_reg[2];

endmodule