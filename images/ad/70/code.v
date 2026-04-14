module top_module(
    input [2:0] sel_mux1, // Select input for the first multiplexer
    input [2:0] sel_mux2, // Select input for the second multiplexer
    input [3:0] data0_mux1, // Input data for the first multiplexer
    input [3:0] data1_mux1,
    input [3:0] data2_mux1,
    input [3:0] data3_mux1,
    input [3:0] data4_mux1,
    input [3:0] data5_mux1,
    input [3:0] data0_mux2, // Input data for the second multiplexer
    input [3:0] data1_mux2,
    input [3:0] data2_mux2,
    input [3:0] data3_mux2,
    input [3:0] data4_mux2,
    input [3:0] data5_mux2,
    input sel_mux, // Select input for choosing between the two multiplexers
    output reg [3:0] out // Output of the adder, changed to reg
);reg [3:0] mux1_out; // Output of the first multiplexer
reg [3:0] mux2_out; // Output of the second multiplexer

// First multiplexer
always @*
begin
    case (sel_mux1)
        3'b000: mux1_out = data0_mux1;
        3'b001: mux1_out = data1_mux1;
        3'b010: mux1_out = data2_mux1;
        3'b011: mux1_out = data3_mux1;
        3'b100: mux1_out = data4_mux1;
        3'b101: mux1_out = data5_mux1;
        default: mux1_out = 4'b0000;
    endcase
end

// Second multiplexer
always @*
begin
    case (sel_mux2)
        3'b000: mux2_out = data0_mux2;
        3'b001: mux2_out = data1_mux2;
        3'b010: mux2_out = data2_mux2;
        3'b011: mux2_out = data3_mux2;
        3'b100: mux2_out = data4_mux2;
        3'b101: mux2_out = data5_mux2;
        default: mux2_out = 4'b0000;
    endcase
end

// Adder
always @*
begin
    out = mux1_out + mux2_out;
end

endmodule