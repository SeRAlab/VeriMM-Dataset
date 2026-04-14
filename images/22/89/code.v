module sipo_shift_register (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [3:0] parallel_out
);

    reg [3:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], serial_in};
        end
    end

    always @(posedge clk) begin
        parallel_out <= shift_reg;
    end

endmodule