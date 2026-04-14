module sipo_shift_register (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire serial_in,
    output reg [4:0] parallel_out
);

reg [4:0] shift_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        shift_reg <= 5'b00000;
    end else if (enable) begin
        shift_reg <= {shift_reg[3:0], serial_in}; // Shift left and insert serial input
    end
end

always @(posedge clk) begin
    parallel_out <= shift_reg; // Output parallel data
end

endmodule