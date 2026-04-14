module top_module(
    input clk, // Added clk input
    input [7:0] data_in,
    input [2:0] shift_amount,
    output reg [7:0] data_out // Changed to reg type
);reg [7:0] reg1, reg2, reg3, reg4;

always @ (posedge clk) begin
    reg1 <= data_in;
    reg2 <= reg1;
    reg3 <= reg2;
    reg4 <= reg3;
end

always @* begin
    // Calculate the data_out based on shift_amount
    case(shift_amount)
        3'd0: data_out = reg4; // No shift
        3'd1: data_out = {1'b0, reg4[7:1]}; // Shift left by 1
        3'd2: data_out = {2'b00, reg4[7:2]}; // Shift left by 2
        3'd3: data_out = {3'b000, reg4[7:3]}; // Shift left by 3
        3'd4: data_out = {4'b0000, reg4[7:4]}; // Shift left by 4
        3'd5: data_out = {5'b00000, reg4[7:5]}; // Shift left by 5
        3'd6: data_out = {6'b000000, reg4[7:6]}; // Shift left by 6
        3'd7: data_out = {7'b0000000, reg4[7]}; // Shift left by 7
        default: data_out = reg4; // Default case
    endcase
end

endmodule