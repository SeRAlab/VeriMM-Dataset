module siso_shift_register (
    input wire clk,
    input wire rst,
    input wire si,
    output reg so
);
    reg [4:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b0;
            so <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[3:0], si}; // Shift left and insert SI
            so <= shift_reg[4]; // Output the MSB
        end
    end
endmodule