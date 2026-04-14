module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    input [2:0] sel, 
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [7:0] out);reg [99:0] shift_reg;
    reg [7:0] mux_out;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data;
        end else if (ena[0]) begin
            shift_reg <= {shift_reg[98:0], shift_reg[99]};
        end else if (ena[1]) begin
            shift_reg <= {shift_reg[0], shift_reg[99:1]};
        end
    end

    always @* begin
        case (sel)
            3'b000: mux_out = data0;
            3'b001: mux_out = data1;
            3'b010: mux_out = data2;
            3'b011: mux_out = data3;
            3'b100: mux_out = data4;
            3'b101: mux_out = data5;
            default: mux_out = 8'b0;
        endcase
    end

    always @* begin
        case (ena)
            2'b00: out = mux_out;
            2'b01: out = {mux_out[3:0], mux_out[3:0]};
            2'b10: out = {mux_out[7:4], mux_out[3:0]};
            2'b11: out = {mux_out[7:4], mux_out[7:4]};
            default: out = 8'b0;
        endcase
    end

endmodule