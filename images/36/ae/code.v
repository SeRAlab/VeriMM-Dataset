module siso_shift_register (
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg data_out
);
    reg [4:0] shift_reg; // 5-bit shift register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b00000; // Reset the shift register
            data_out <= 0;
        end else begin
            data_out <= shift_reg[0]; // Output the oldest bit
            shift_reg <= {data_in, shift_reg[4:1]}; // Shift in new data
        end
    end
endmodule