module PISO(
    input wire [4:0] data_in,
    input wire load,
    input wire clk,
    input wire reset,
    output reg serial_out
);
    reg [4:0] shift_reg;
    integer count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b0;
            serial_out <= 1'b0;
            count <= 0;
        end else if (load) begin
            shift_reg <= data_in;
            count <= 5; // Load data and set count to 5
        end else if (count > 0) begin
            serial_out <= shift_reg[4]; // Output the MSB
            shift_reg <= {shift_reg[3:0], 1'b0}; // Shift left
            count <= count - 1; // Decrement count
        end
    end
endmodule