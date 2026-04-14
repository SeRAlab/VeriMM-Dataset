module top_module(
    input clk,
    input rst,
    input [3:0] shift_direction,
    input [15:0] data_in,
    output reg [15:0] shifted_data_out,
    output reg [3:0] count_out,
    output reg xor_out
);reg [3:0] count_reg;
reg [15:0] shift_reg;

always @(posedge clk) begin
    if (rst) begin
        count_reg <= 4'b0;
        shift_reg <= 16'b0;
    end else begin
        if (shift_direction == 4'b0001) begin // shift left
            count_reg <= count_reg + 1;
            shift_reg <= {shift_reg[13:0], data_in[15:14]};
        end else if (shift_direction == 4'b0010) begin // shift right
            count_reg <= count_reg - 1;
            shift_reg <= {data_in[1:0], shift_reg[15:2]};
        end else begin // no shift
            count_reg <= count_reg;
            shift_reg <= data_in;
        end
    end
end

assign shifted_data_out = shift_reg;
assign count_out = count_reg;

function [15:0] xor_func;
    input [15:0] data_in;
    input [3:0] count_in;
    begin
        xor_func = data_in ^ count_in;
    end
endfunction

assign xor_out = xor_func(shifted_data_out, count_out);

endmodule