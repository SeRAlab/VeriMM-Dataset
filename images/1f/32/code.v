module shift_register (
    input clk,
    input rst,
    input shift_left,
    input [7:0] input_data,
    output reg [7:0] register_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        register_out <= 8'b00000000; // Reset the register
    end else if (shift_left) begin
        register_out <= {register_out[6:0], input_data[0]}; // Shift left
    end else begin
        register_out <= {input_data[7], register_out[7:1]}; // Shift right
    end
end

endmodule