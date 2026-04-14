module shift_register (
    input clk,
    input reset,
    input load,
    input shift,
    input [7:0] data_in,
    output [7:0] q
);

    reg [7:0] reg_data;  // 8-bit shift register

    always @(posedge clk) begin
        if (reset) begin
            reg_data <= 8'b00000000;  // Reset the shift register to 0
        end else if (load) begin
            reg_data <= data_in;  // Load the value into the shift register
        end else if (shift) begin
            reg_data <= reg_data << 1;  // Shift left the shift register
        end
    end

    assign q = reg_data;

endmodule