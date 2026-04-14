module sipo_shift_register (
    input wire clk,
    input wire reset,
    input wire serial_in,
    input wire load,
    output reg [3:0] parallel_out
);
    reg [3:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            parallel_out <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], serial_in}; // Shift left and insert serial input
            if (load) begin
                parallel_out <= shift_reg; // Load parallel output when load is asserted
            end
        end
    end
endmodule