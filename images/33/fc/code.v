module PIPO_shift_register #(parameter WIDTH = 8) (
    input wire clk,
    input wire load,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);
    reg [WIDTH-1:0] register;

    always @(posedge clk) begin
        if (load) begin
            register <= data_in; // Load data into register
        end else begin
            data_out <= register; // Output current data
            register <= {1'b0, register[WIDTH-1:1]}; // Shift left
        end
    end
endmodule