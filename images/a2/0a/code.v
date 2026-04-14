module top_module(
    input [3:0] sel,
    input [7:0] in0,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [7:0] in4,
    input [7:0] in5,
    input [7:0] in6,
    input [7:0] in7,
    output reg out
);reg [3:0] sel_reg;
reg [7:0] selected_vector;
wire [3:0] sel_inv;
wire [7:0] selected_vector_inv;
wire nand_out;

// 256-to-1 multiplexer
always @(*) begin
    case(sel)
        4'b0000: selected_vector = in0;
        4'b0001: selected_vector = in1;
        4'b0010: selected_vector = in2;
        4'b0011: selected_vector = in3;
        4'b0100: selected_vector = in4;
        4'b0101: selected_vector = in5;
        4'b0110: selected_vector = in6;
        4'b0111: selected_vector = in7;
        // default: selected_vector = 8'b0; // optional default case
    endcase
end

// Invert the selection input and the selected vector
assign sel_inv = ~sel;
assign selected_vector_inv = ~selected_vector;

// NAND gate
assign nand_out = ~(selected_vector_inv[0] & selected_vector_inv[1] & selected_vector_inv[2] & selected_vector_inv[3]);

// Final output module
always @(nand_out) begin
    if(nand_out) begin
        out = 1'b1;
    end else begin
        out = 1'b0;
    end
end

endmodule