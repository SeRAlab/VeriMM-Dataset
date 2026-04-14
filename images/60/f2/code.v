module top_module(
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);reg [3:0] mux1_out;
reg [3:0] and_out;

// 6-to-1 multiplexer to select data input based on sel
always @*
begin
    case (sel)
        3'b000: mux1_out = data0;
        3'b001: mux1_out = data1;
        3'b010: mux1_out = data2;
        3'b011: mux1_out = data3;
        3'b100: mux1_out = data4;
        3'b101: mux1_out = data5;
        default: mux1_out = 4'b0;
    endcase
end

// Generate bitwise AND of two least significant bits of all data inputs
always @*
begin
    case (sel)
        3'b110: and_out = &{data5[1:0], data4[1:0], data3[1:0], data2[1:0], data1[1:0], data0[1:0]};
        3'b111: and_out = &{data5[1:0], data4[1:0], data3[1:0], data2[1:0], data1[1:0], data0[1:0]};
        default: and_out = 4'b0;
    endcase
end

// 6-to-1 multiplexer to select between mux1_out and and_out
always @*
begin
    case (sel)
        3'b110: out = and_out;
        3'b111: out = and_out;
        default: out = mux1_out;
    endcase
end

endmodule