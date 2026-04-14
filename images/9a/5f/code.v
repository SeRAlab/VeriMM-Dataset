module top_module(
    input clk,
    input areset,  // Async active-high reset to zero
    input load,
    input ena,
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] q,
    output reg xor_out
);reg [3:0] shift_reg [3:0];
reg [1:0] sel_reg;
wire [3:0] mux_out;

// 6-to-1 multiplexer implementation
wire [3:0] in [5:0]; // Array of 6 inputs
assign in[0] = data0;
assign in[1] = data1;
assign in[2] = data2;
assign in[3] = data3;
assign in[4] = data4;
assign in[5] = data5;

assign mux_out = (sel == 3'b000) ? in[0] :
                 (sel == 3'b001) ? in[1] :
                 (sel == 3'b010) ? in[2] :
                 (sel == 3'b011) ? in[3] :
                 (sel == 3'b100) ? in[4] :
                 (sel == 3'b101) ? in[5] : 4'b0000; // Default case

// Shift register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg[0] <= 4'b0;
        shift_reg[1] <= 4'b0;
        shift_reg[2] <= 4'b0;
        shift_reg[3] <= 4'b0;
        sel_reg <= 2'b0;
    end else if (load) begin
        shift_reg[0] <= mux_out;
        shift_reg[1] <= 4'b0;
        shift_reg[2] <= 4'b0;
        shift_reg[3] <= 4'b0;
        sel_reg <= 2'b0;
    end else if (ena) begin
        shift_reg[0] <= shift_reg[1];
        shift_reg[1] <= shift_reg[2];
        shift_reg[2] <= shift_reg[3];
        shift_reg[3] <= shift_reg[3]; // Maintaining the last stage
        sel_reg <= sel_reg + 1;
    end
end

// Output
always @(*) begin
    q = shift_reg[0];
    xor_out = q ^ mux_out;
end

endmodule