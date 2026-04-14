module shift_register(
    input clk,
    input reset,
    input in,
    output [7:0] out
);
    reg [7:0] shift_reg;
    always @(posedge clk or posedge reset) begin
        if (reset)
            shift_reg <= 8'b0;
        else
            shift_reg <= {shift_reg[6:0], in};
    end
    assign out = shift_reg;
endmodule