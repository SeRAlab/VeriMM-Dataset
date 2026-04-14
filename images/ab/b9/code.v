module top_module(
    input clk,
    input rst,  // Async active-high reset to zero
    input load,
    input ena,
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] q
);reg [3:0] shift_reg;
reg [2:0] sel_reg;
wire [3:0] mux_out;

// 6-to-1 multiplexer
assign mux_out = (sel == 0) ? data0 :
                 (sel == 1) ? data1 :
                 (sel == 2) ? data2 :
                 (sel == 3) ? data3 :
                 (sel == 4) ? data4 :
                 (sel == 5) ? data5 :
                 4'b0;

// Shift register
always @(posedge clk) begin
    if (rst) begin
        shift_reg <= 4'b0;
        sel_reg <= 3'b0;
    end else if (load && ena) begin
        shift_reg <= mux_out;
        sel_reg <= sel;
    end else if (ena) begin
        shift_reg <= {shift_reg[2:0], mux_out[3]};
        sel_reg <= {sel_reg[1:0], sel};
    end
end

// Output
always @(posedge clk) begin
    if (rst) begin
        q <= 4'b0;
    end else begin
        q <= shift_reg;
    end
end

endmodule