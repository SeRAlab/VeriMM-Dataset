module PIPO_Shift_Register (
    input wire clk,
    input wire rst,
    input wire [4:0] data_in,
    input wire load,
    input wire output_enable,
    output reg [4:0] data_out
);
    reg [4:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b00000;
        end else if (load) begin
            shift_reg <= data_in;
        end
    end

    always @(posedge clk) begin
        if (output_enable) begin
            data_out <= shift_reg;
        end
    end
endmodule