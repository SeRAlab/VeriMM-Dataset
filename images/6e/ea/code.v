module piso_shift_register (
    input clk,
    input reset,
    input [7:0] parallel_in,
    input load,
    output reg serial_out
);

    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 8'b00000000;
            serial_out <= 0;
        end else if (load) begin
            shift_reg <= parallel_in;
        end else begin
            serial_out <= shift_reg[0];
            shift_reg <= {1'b0, shift_reg[7:1]};
        end
    end

endmodule