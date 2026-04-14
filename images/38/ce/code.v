module sipo_shift_register (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [4:0] parallel_out
);
    reg [4:0] shift_reg;
    integer count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b0;
            parallel_out <= 5'b0;
            count <= 0;
        end else begin
            if (count < 5) begin
                shift_reg <= {shift_reg[3:0], serial_in}; // Shift left and add serial input
                count <= count + 1;
            end
            if (count == 4) begin
                parallel_out <= shift_reg; // Output parallel data after 5 bits
            end
        end
    end
endmodule