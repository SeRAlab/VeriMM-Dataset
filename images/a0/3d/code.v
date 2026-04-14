module top_module(
    input clk,
    input reset,
    input load,
    input [3:0] parallel_in,
    output reg serial_out);reg [3:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            serial_out <= 0;
        end else if (load) begin
            shift_reg <= parallel_in;
        end else begin
            serial_out <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
        end
    end

endmodule