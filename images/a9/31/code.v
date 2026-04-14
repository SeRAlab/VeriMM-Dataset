module top_module(
    input clken,
    input clock,
    input [1:0] denom,
    input [63:0] numer,
    output [63:0] quotient,
    output [1:0] remain
);wire [63:0] wire_mgl_prim1_quotient;
    wire [1:0] wire_mgl_prim1_remain;

    // Declare a parameterized division operation as there is no lpm_divide module defined
    reg [63:0] quotient_reg;
    reg [1:0] remain_reg;

    always @(posedge clock) begin
        if (clken) begin
            if (denom != 0) begin
                quotient_reg <= numer / denom; // Perform division
                remain_reg <= numer % denom;    // Compute remainder
            end else begin
                quotient_reg <= 0; // Handle division by zero case
                remain_reg <= 0;   // Handle division by zero case
            end
        end
    end

    assign quotient = quotient_reg;
    assign remain = remain_reg;

endmodule