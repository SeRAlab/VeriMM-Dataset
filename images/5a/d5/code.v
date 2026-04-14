module top_module(
    input clk,
    input reset,
    input [255:0] in, // 256-bit input for the shift register
    output [7:0] q // 8-bit output from the functional module
);reg [255:0] shift_reg; // 256-bit shift register
    wire [7:0] mux_out; // 8-bit output of the multiplexer
    wire [2:0] select; // select lines for the multiplexer
    
    assign select = shift_reg[2:0]; // use the first 3 bits of the shift register as select lines
    
    // 8-to-1 multiplexer
    assign mux_out = {in[31:24] & select[0], in[63:56] & select[1], in[95:88] & select[2], in[127:120] & select[3], in[159:152] & select[4], in[191:184] & select[5], in[223:216] & select[6], in[255:248] & select[7]};
    
    // bitwise AND of the selected input and the current contents of the shift register
    assign q = mux_out & shift_reg[7:0];
    
    // bitwise OR of the multiplexer output and the shift register output
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 256'h0;
        end else begin
            shift_reg <= {in, shift_reg[255:1]};
        end
    end
    
endmodule