module top_module( 
    input clk, 
    input reset,
    input select, 
    input [7:0] d1, 
    input [7:0] d2, 
    output [7:0] q,
    output [7:0] out_sum,
    output [7:0] out_comp 
);reg [7:0] reg1, reg2;
wire [7:0] sum_out, comp_out;

// Register 1
always @(posedge clk) begin
    if (reset) begin
        reg1 <= 8'b0;
    end else begin
        reg1 <= d1;
    end
end

// Register 2
always @(posedge clk) begin
    if (reset) begin
        reg2 <= 8'b0;
    end else begin
        reg2 <= d2;
    end
end

// Sum functional module
assign sum_out = reg1 + reg2;

// Complement functional module
assign comp_out = ~sum_out;

// 2-level tree of 4:1 multiplexers
wire [7:0] mux1_out1, mux1_out2, mux2_out;

assign mux1_out1 = select ? comp_out : sum_out;
assign mux1_out2 = select ? sum_out : comp_out;
assign mux2_out = select ? mux1_out2 : mux1_out1;

assign q = mux2_out;
assign out_sum = sum_out;
assign out_comp = comp_out;

endmodule