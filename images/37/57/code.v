module PISO (
    input wire [4:0] D,
    input wire CLK,
    input wire LOAD,
    output reg Q
);
    reg [4:0] shift_reg;
    integer count;

    always @(posedge CLK) begin
        if (LOAD) begin
            shift_reg <= D;
            count <= 4; // Load data and start shifting from the last bit
        end else if (count >= 0) begin
            Q <= shift_reg[count];
            count <= count - 1;
        end
    end
endmodule