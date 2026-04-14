module PIPO_Shift_Register (
    input wire clk,
    input wire load,
    input wire [4:0] data_in,
    input wire read,
    output reg [4:0] data_out
);
    reg [4:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data_in; // Load input data into shift register
        end
    end

    always @(posedge clk) begin
        if (read) begin
            data_out <= shift_reg; // Output the current value of the shift register
        end
    end
endmodule