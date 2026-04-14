module piso_shift_register (
    input wire clk,
    input wire load,
    input wire [3:0] data_in,
    output reg serial_out
);
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data_in;  // Load data in parallel
        end else begin
            serial_out <= shift_reg[3];  // Shift out the MSB
            shift_reg <= {shift_reg[2:0], 1'b0};  // Shift left
        end
    end
endmodule