module siso_shift_register #(parameter SIZE = 5) (
    input clk,
    input rst,
    input serial_in,
    output reg serial_out
);
    reg [SIZE-1:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 0;
            serial_out <= 0;
        end else begin
            shift_reg <= {shift_reg[SIZE-2:0], serial_in};
            serial_out <= shift_reg[SIZE-1];
        end
    end
endmodule