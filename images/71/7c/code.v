module shift_reg_8bit (
    input wire clk,
    input wire load,
    input wire shift,
    input wire [7:0] data_in,
    output reg serial_out
    );

reg [7:0] shift_reg;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data_in;
    end else if (shift) begin
        serial_out <= shift_reg[7];
        shift_reg <= shift_reg << 1;
    end
end

endmodule