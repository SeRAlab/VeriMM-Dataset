module top_module(
    input clk,
    input [7:0] data_in1,
    input [7:0] data_in2,
    output reg [7:0] q_out
);reg [7:0] shift_reg [0:7];

always @(posedge clk) begin
    shift_reg[0] <= data_in1;
    shift_reg[1] <= shift_reg[0];
    shift_reg[2] <= shift_reg[1];
    shift_reg[3] <= shift_reg[2];
    shift_reg[4] <= shift_reg[3];
    shift_reg[5] <= shift_reg[4];
    shift_reg[6] <= shift_reg[5];
    shift_reg[7] <= data_in2;
end

assign q_out = shift_reg[7];

endmodule