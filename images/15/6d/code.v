module PIPO_Shift_Register(
    input wire clk,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data_in;  // Load data in parallel
        end else begin
            data_out <= shift_reg;  // Output the current state
        end
    end
endmodule