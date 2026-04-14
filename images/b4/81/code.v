module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q);reg [99:0] shift_reg;
    reg [99:0] shifted_data;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data;
        end else begin
            if (ena == 2'b01) begin // Rotate right by one bit
                shifted_data[0] <= shift_reg[99];
                shifted_data[99:1] <= shift_reg[98:0];
            end else if (ena == 2'b10) begin // Rotate left by one bit
                shifted_data[98:0] <= shift_reg[99:1];
                shifted_data[99] <= shift_reg[0];
            end else begin // No rotation
                shifted_data <= shift_reg;
            end
            shift_reg <= shifted_data;
        end
    end

    assign q = shift_reg;

endmodule