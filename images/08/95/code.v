module SIPO_Shift_Register (
    input wire clk,
    input wire reset,
    input wire serial_in,
    input wire load,
    output reg [7:0] parallel_out
);
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 8'b0;
            parallel_out <= 8'b0;
        end
        else begin
            shift_reg <= {shift_reg[6:0], serial_in}; // Shift left and input serial_in
            if (load) begin
                parallel_out <= shift_reg; // Load the shift register into output
            end
        end
    end
endmodule