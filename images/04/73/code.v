module sipo_shift_register #(parameter WIDTH = 5) (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [WIDTH-1:0] parallel_out,
    output reg data_valid
);
    reg [WIDTH-1:0] shift_reg;
    integer count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 0;
            count <= 0;
            data_valid <= 0;
        end else begin
            if (count < WIDTH) begin
                shift_reg <= {shift_reg[WIDTH-2:0], serial_in};
                count <= count + 1;
            end
            if (count == WIDTH - 1) begin
                parallel_out <= shift_reg;
                data_valid <= 1;
            end
        end
    end
endmodule