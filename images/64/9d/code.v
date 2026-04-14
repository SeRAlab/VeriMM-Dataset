module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    input [31:0] in,
    output [31:0] out);// 100-bit left/right rotator
    reg [99:0] rot_data;
    always @(posedge clk) begin
        if (load) rot_data <= data;
        else if (ena[0]) rot_data <= {rot_data[98:0], rot_data[99]};
        else if (ena[1]) rot_data <= {rot_data[0], rot_data[99:1]};
    end

    // Byte reordering module
    reg [7:0] shift_reg [3:0];
    always @(posedge clk) begin
        if (load) begin
            shift_reg[0] <= in[7:0];
            shift_reg[1] <= in[15:8];
            shift_reg[2] <= in[23:16];
            shift_reg[3] <= in[31:24];
        end
        else begin
            shift_reg[0] <= shift_reg[1];
            shift_reg[1] <= shift_reg[2];
            shift_reg[2] <= shift_reg[3];
            shift_reg[3] <= in[31:24];
        end
    end
    assign out = {shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]} | rot_data[31:0];

endmodule