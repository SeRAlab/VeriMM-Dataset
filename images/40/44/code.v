module pipo_shift_register (
    input wire clk,
    input wire load,
    input wire shift,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] register;

    always @(posedge clk) begin
        if (load) begin
            register <= data_in; // Load data in parallel
        end else if (shift) begin
            data_out <= register; // Output current data
            register <= {1'b0, register[4:1]}; // Shift left
        end
    end
endmodule