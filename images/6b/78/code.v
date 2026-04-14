module top_module(
    input [7:0] in,
    input [2:0] select,
    output reg [7:0] shifted_out
);always @(*) begin
        case (select)
            3'b000: shifted_out = in;
            3'b001: shifted_out = {in[6:0], 1'b0}; // Shift left
            3'b010: shifted_out = {1'b0, in[7:1]}; // Shift right
            3'b011: shifted_out = {in[5:0], 2'b00}; // Shift left by 2
            3'b100: shifted_out = {2'b00, in[7:2]}; // Shift right by 2
            // Add additional shifting cases as needed
            default: shifted_out = in; // Default to no shift
        endcase
    end
endmodule