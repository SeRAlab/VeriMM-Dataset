module top_module(
    input clk,          // Clock input for the shift register
    input reset,        // Synchronous active-high reset for the shift register
    input [3:0] data0,  // Input data for multiplexer
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    input [2:0] sel,    // Select input for multiplexer
    output [7:0] out    // 8-bit output from the functional module
);reg [2:0] shift_reg;    // 3-bit shift register
reg [3:0] mux_out;      // Output from multiplexer

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 3'b0;
    end else begin
        shift_reg <= {data0[0], shift_reg[2:1]};
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
        default: mux_out = 4'b0;
    endcase
end

assign out = {mux_out, shift_reg};

endmodule