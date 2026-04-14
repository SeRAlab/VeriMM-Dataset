module shift_register (
    input clk,
    input reset,
    input load,
    input [7:0] data_in,
    output [7:0] data_out
);

    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;  // Reset the register to 0
        end else if (load) begin
            shift_reg <= {shift_reg[6:0], data_in[7]};  // Shift left and load MSB
        end
    end

    assign data_out = shift_reg;

endmodule