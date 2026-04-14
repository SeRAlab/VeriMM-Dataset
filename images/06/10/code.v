module PIPO_Shift_Register (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b0;
            data_out <= 5'b0;
        end else if (load) begin
            shift_reg <= data_in;
        end else begin
            data_out <= shift_reg;
            shift_reg <= {1'b0, shift_reg[4:1]};
        end
    end
endmodule