module PISO (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [4:0] parallel_in,
    input wire shift_en,
    output reg serial_out
);
    reg [4:0] shift_reg;
    integer count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b0;
            serial_out <= 1'b0;
            count <= 0;
        end else if (load) begin
            shift_reg <= parallel_in;
            count <= 0;
        end else if (shift_en && count < 5) begin
            serial_out <= shift_reg[4]; // output the MSB first
            shift_reg <= {shift_reg[3:0], 1'b0}; // shift left
            count <= count + 1;
        end
    end
endmodule