module PISO (
    input wire [3:0] parallel_in,
    input wire load,
    input wire clk,
    output reg serial_out
);
    reg [3:0] shift_reg;
    
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load data in parallel
        end else begin
            serial_out <= shift_reg[3]; // Output MSB
            shift_reg <= {shift_reg[2:0], 1'b0}; // Shift right
        end
    end
endmodule