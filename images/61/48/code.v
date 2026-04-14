module top_module(
    input [2:0] select,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);reg [3:0] mux_out;
reg [3:0] xor_out;
reg [3:0] and_out;

wire bdd_out;

// 6-to-1 multiplexer
always @*
begin
    case (select)
        3'b000: mux_out = data0;
        3'b001: mux_out = data1;
        3'b010: mux_out = data2;
        3'b011: mux_out = data3;
        3'b100: mux_out = data4;
        3'b101: mux_out = data5;
        default: mux_out = 4'b0000;
    endcase
end

// XOR and AND gates
always @*
begin
    if (select <= 3'b010)
        xor_out = mux_out ^ 4'b1010;
    else
        and_out = mux_out & 4'b0101;
end

// BDD-based functional module
function [1:0] bdd_func;
input [3:0] a, b;
begin
    case ({a,b})
        4'b0000, 4'b0010, 4'b0100, 4'b0110, 4'b1000, 4'b1010, 4'b1100: bdd_func = 2'b00;
        4'b0001, 4'b0011, 4'b0101, 4'b0111, 4'b1001, 4'b1011, 4'b1101: bdd_func = 2'b01;
        default: bdd_func = 2'b10;
    endcase
end
endfunction

// Final output
always @*
begin
    if (select <= 3'b010)
        out = bdd_func(xor_out, 4'b1010);
    else
        out = bdd_func(and_out, 4'b0101);
end

endmodule