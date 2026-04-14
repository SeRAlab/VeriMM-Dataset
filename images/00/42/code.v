module PISO_5bit (
    input wire clk,
    input wire load,
    input wire reset,
    input wire [4:0] data,
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
            shift_reg <= data;
            count <= 0; // Reset count when loading data
        end else if (count < 5) begin
            serial_out <= shift_reg[4]; // Output MSB
            shift_reg <= {1'b0, shift_reg[4:1]}; // Shift left
            count <= count + 1; // Increment count
        end
    end
endmodule