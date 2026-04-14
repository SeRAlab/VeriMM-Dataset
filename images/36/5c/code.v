module SIPO (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [4:0] parallel_out
);
    reg [4:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b00000;
            parallel_out <= 5'b00000;
        end else begin
            shift_reg <= {shift_reg[3:0], serial_in}; // Shift left and input new bit
            parallel_out <= shift_reg; // Output the parallel data
        end
    end
endmodule