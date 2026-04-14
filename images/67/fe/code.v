module piso_shift_register(
    input clk,
    input reset,
    input load,
    input [7:0] data,
    output reg q
);

    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset
            shift_reg <= 8'b00000000;
        end else if (load) begin
            // Load the shift register with data
            shift_reg <= data;
        end else begin
            // Shift right
            shift_reg <= {1'b0, shift_reg[7:1]};
        end
        q <= shift_reg[0];
    end

endmodule