module PISO (
    input clk,
    input rst_n,
    input load,
    input shift,
    input [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;
    integer counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 5'b0;
            serial_out <= 1'b0;
            counter <= 0;
        end else begin
            if (load) begin
                shift_reg <= parallel_in;
                counter <= 5; // Load the 5 bits
            end else if (shift && counter > 0) begin
                serial_out <= shift_reg[4];
                shift_reg <= {shift_reg[3:0], 1'b0}; // Shift left
                counter <= counter - 1;
            end
        end
    end
endmodule