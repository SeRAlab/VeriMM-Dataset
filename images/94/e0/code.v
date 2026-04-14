module top_module(
    input [7:0] in, // 8-bit input for parity checker
    input [2:0] sel, // 3-bit input for multiplexer selection
    input [3:0] data0, // 4-bit input data 0 for multiplexer
    input [3:0] data1, // 4-bit input data 1 for multiplexer
    input [3:0] data2, // 4-bit input data 2 for multiplexer
    input [3:0] data3, // 4-bit input data 3 for multiplexer
    input [3:0] data4, // 4-bit input data 4 for multiplexer
    input [3:0] data5, // 4-bit input data 5 for multiplexer
    output reg [3:0] out // Change to reg type as out needs to be assigned in an always block
);// Parity Checker Module
reg parity;
always @(*) begin
    parity = ^in;
end

// Multiplexer Module
reg [3:0] mux_out;
always @(*) begin
    case (sel)
        3'b000: mux_out = data0;
        3'b001: mux_out = data1;
        3'b010: mux_out = data2;
        3'b011: mux_out = data3;
        3'b100: mux_out = data4;
        3'b101: mux_out = data5;
        default: mux_out = 4'b0000;
    endcase
end

// Functional Module
always @(*) begin
    if (parity == 1'b1) begin
        out = mux_out;
    end else begin
        out = 4'b0000;
    end
end

endmodule