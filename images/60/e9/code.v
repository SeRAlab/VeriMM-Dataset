module top_module(
    input clk,
    input rst,
    input load,
    input direction,
    input [3:0] data_in,
    output reg [3:0] data_out
);reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= 4'b0;
            data_out <= 4'b0;
        end
        else if (load) begin
            shift_reg <= data_in;
            data_out <= data_in;
        end
        else begin
            if (direction) begin
                shift_reg <= {shift_reg[2:0], shift_reg[3]}; // Logical left shift
                data_out <= shift_reg;
            end
            else begin
                shift_reg <= {shift_reg[0], shift_reg[3:1]}; // Logical right shift (fixed order)
                data_out <= shift_reg;
            end
        end
    end

endmodule