module piso_shift_register (
    input wire [4:0] parallel_in,
    input wire clk,
    input wire reset,
    input wire load,
    output reg serial_out
);

reg [4:0] shift_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 5'b0;
        serial_out <= 1'b0;
    end else if (load) begin
        shift_reg <= parallel_in;
        serial_out <= shift_reg[0];
    end else begin
        serial_out <= shift_reg[0];
        shift_reg <= {1'b0, shift_reg[4:1]}; // Shift left and insert 0
    end
end

endmodule