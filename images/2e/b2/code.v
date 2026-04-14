module PISO (
    input wire clk,
    input wire load,
    input wire [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;
    integer count;

    initial begin
        count = 0;
        shift_reg = 5'b0;
        serial_out = 1'b0;
    end

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in;
            count <= 0;
        end else if (count < 5) begin
            serial_out <= shift_reg[4]; // Shift out the MSB
            shift_reg <= {shift_reg[3:0], 1'b0}; // Shift left
            count <= count + 1;
        end
    end
endmodule