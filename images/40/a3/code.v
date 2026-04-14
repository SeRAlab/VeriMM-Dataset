module PIPO_Shift_Register (
    input clk,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] register;

    always @(posedge clk) begin
        if (load) begin
            register <= data_in; // Load the input data
        end
        data_out <= register; // Output the current register value
    end
endmodule