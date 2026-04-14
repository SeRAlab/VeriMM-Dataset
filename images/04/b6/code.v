module sipo_shift_register (
    input clk,
    input reset,
    input serial_in,
    output reg [4:0] parallel_out
);

    reg [4:0] shift_reg;
    integer count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b0;
            count <= 0;
        end else begin
            if (count < 5) begin
                shift_reg <= {shift_reg[3:0], serial_in};
                count <= count + 1;
            end
            if (count == 4) begin
                parallel_out <= shift_reg;
            end
        end
    end
endmodule