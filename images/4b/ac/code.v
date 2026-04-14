module top_module(
    input clk,
    input load,
    input [3:0] in,
    output [3:0] out,
    output ser_out
);reg [3:0] shift_reg;
    reg ser_out_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= in;
        end else begin
            shift_reg <= {shift_reg[2:0], shift_reg[3]};
        end
        ser_out_reg <= shift_reg[3];
    end

    assign out = shift_reg;
    assign ser_out = ser_out_reg;

endmodule