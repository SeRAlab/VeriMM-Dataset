module ShiftRegister (
    input clk,
    input rst,
    input load,
    input en,
    input [7:0] data_in,
    output reg data_out
);
    reg [7:0] shift_reg;
    
    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= 8'b0;
            data_out <= 1'b0;
        end else if (load) begin
            shift_reg <= data_in;
        end else if (en) begin
            data_out <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
        end
    end
endmodule