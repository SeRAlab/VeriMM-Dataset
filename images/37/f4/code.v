module shift_register (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire new_bit,
    output reg [3:0] reg_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        reg_out <= 4'b0000;
    end else if (enable) begin
        reg_out <= {reg_out[2:0], new_bit}; // Shift left and insert new_bit
    end
end

endmodule