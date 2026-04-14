module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input d,          // 1-bit input for the shift register
    input [1023:0] in,// 1024-bit input vector for the multiplexer
    input [7:0] sel,  // Select input to choose between the shift register and the multiplexer
    output [3:0] q    // 4-bit output from the final functional module
);// Shift Register
reg [2:0] shift_reg;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 3'b001;
    end else begin
        shift_reg <= {shift_reg[0], shift_reg[2:1]};
    end
end

// 256-to-1 Multiplexer
wire [3:0] mux_out;
reg [255:0] priority_encoder;
integer i;
always @(in) begin
    for (i = 0; i < 256; i = i + 1) begin
        priority_encoder[i] = (in[4*i +: 4] != 4'b0) ? 1'b1 : 1'b0;
    end
end
assign mux_out = in[4*(256'd1 << sel) -: 4];

// Control Logic
wire [3:0] shift_reg_out;
assign shift_reg_out = (shift_reg == 3'b001) ? 4'b0001 : (shift_reg == 3'b010) ? 4'b0010 : 4'b0100;

wire [3:0] selected_output;
assign selected_output = (sel == 8'b0) ? shift_reg_out : mux_out;

// Additive Function
reg [4:0] adder_output;
always @(selected_output or shift_reg_out) begin
    adder_output = selected_output + shift_reg_out;
end

assign q = adder_output[3:0];

endmodule