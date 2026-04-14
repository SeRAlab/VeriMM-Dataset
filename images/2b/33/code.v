module PIPO_Shift_Register (
    input wire clk,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data_in; // Load data into shift register
        end
        data_out <= shift_reg; // Always output the shift register content
    end
endmodule