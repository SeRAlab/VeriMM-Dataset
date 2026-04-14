module SIPO_Shift_Register (
    input clk,
    input reset,
    input serial_in,
    output reg [4:0] parallel_out
);

    reg [4:0] shift_reg;
    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b0;
            count <= 3'b0;
            parallel_out <= 5'b0;
        end else if (count < 5) begin
            shift_reg <= {shift_reg[3:0], serial_in};
            count <= count + 1;
            if (count == 4) begin
                parallel_out <= shift_reg;
            end
        end
    end
endmodule