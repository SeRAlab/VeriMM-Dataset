module SIPO (
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg [7:0] parallel_out
);

    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 8'b0;
            parallel_out <= 8'b0;
        end else begin
            shift_reg <= {shift_reg[6:0], serial_in}; // Shift left and insert new bit
            parallel_out <= shift_reg; // Output parallel data
        end
    end

endmodule