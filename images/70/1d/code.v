module top_module( 
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data0,
    input [99:0] data1,
    input [99:0] data2,
    input [99:0] data3,
    input [99:0] data4,
    input [99:0] data5,
    input [2:0] sel,
    output reg [99:0] q 
);reg [99:0] shift_reg;
reg [99:0] mux_sel;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= mux_sel;
    end else begin
        if (ena[0]) begin
            shift_reg <= {shift_reg[98:0], shift_reg[99]};
        end
        if (ena[1]) begin
            shift_reg <= {shift_reg[0], shift_reg[99:1]}; // Fixed the order of the part select
        end
    end
end

always @(*) begin
    case (sel)
        3'b000: mux_sel = data0;
        3'b001: mux_sel = data1;
        3'b010: mux_sel = data2;
        3'b011: mux_sel = data3;
        3'b100: mux_sel = data4;
        3'b101: mux_sel = data5;
        default: mux_sel = data0;
    endcase
end

assign q = shift_reg ^ mux_sel;

endmodule