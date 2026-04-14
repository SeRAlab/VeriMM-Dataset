module top_module(
    input clk,
    input reset,
    input d,
    input select,
    input [4:0] in,
    output out_and,
    output out_or,
    output out_nor,
    output reg [2:0] final_output // Changed to reg type
);// 3-bit shift register
    reg [2:0] shift_reg;
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
        end else begin
            shift_reg <= {shift_reg[1:0], d};
        end
    end
    
    // Multiplexer to select output from shift register
    wire [2:0] shift_reg_out = {shift_reg[2], shift_reg[1], shift_reg[0]};
    wire [2:0] mux_out;
    assign mux_out = (select) ? {shift_reg_out, 3'b0} : {3'b0, in};
    
    // 5-input logic gate
    wire and_out = in[0] & in[1] & in[2] & in[3] & in[4];
    wire or_out = in[0] | in[1] | in[2] | in[3] | in[4];
    wire nor_out = ~(in[0] | in[1] | in[2] | in[3] | in[4]);
    
    // 2-to-4 decoder with enable
    wire [3:0] decoder_out;
    assign decoder_out = (in[4]) ? 4'b1110 : 4'b0001;
    
    // Functional module to produce final output
    always @(*) begin
        case (select)
            1'b0: final_output = {mux_out[2], mux_out[1], mux_out[0]};
            1'b1: final_output = {and_out, or_out, nor_out};
        endcase
    end
    
    // Output assignments
    assign out_and = and_out;
    assign out_or = or_out;
    assign out_nor = nor_out;
    
endmodule