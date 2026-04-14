module PISO #(
    parameter WIDTH = 4
)(
    input clk,
    input load,
    input [WIDTH-1:0] parallel_in,
    output reg serial_out
);
    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in;  // Load parallel data
        end else begin
            serial_out <= shift_reg[WIDTH-1]; // Shift out the MSB
            shift_reg <= {shift_reg[WIDTH-2:0], 1'b0}; // Shift left
        end
    end
endmodule