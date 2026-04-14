module piso_shift_register (
    input clk,
    input reset,
    input load,
    input [7:0] data,
    output reg q);

    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) shift_reg <= 8'b00000000;
        else if (load) shift_reg <= data;
        else shift_reg <= {shift_reg[6:0], 1'b0};
    end

    assign q = shift_reg[7];
endmodule