module top_module(
    input [7:0] A,
    input [7:0] B,
    output [15:0] Y
);reg [7:0] a_reg;
reg [7:0] b_reg;
reg [15:0] y_reg;

wire [7:0] a_pipe [3:0];
wire [7:0] b_pipe [3:0];
wire [15:0] y_pipe [3:0];

assign a_pipe[0] = A;
assign b_pipe[0] = B;

genvar i;
generate
    for (i = 0; i < 3; i = i + 1) begin : stage
        assign a_pipe[i+1][7:6] = a_pipe[i][7:6] + b_pipe[i][7:6];
        assign a_pipe[i+1][5:4] = a_pipe[i][5:4] + b_pipe[i][5:4];
        assign a_pipe[i+1][3:2] = a_pipe[i][3:2] + b_pipe[i][3:2];
        assign a_pipe[i+1][1:0] = a_pipe[i][1:0] + b_pipe[i][1:0];

        assign b_pipe[i+1][7:6] = a_pipe[i][7:6] & b_pipe[i][7:6];
        assign b_pipe[i+1][5:4] = a_pipe[i][5:4] & b_pipe[i][5:4];
        assign b_pipe[i+1][3:2] = a_pipe[i][3:2] & b_pipe[i][3:2];
        assign b_pipe[i+1][1:0] = a_pipe[i][1:0] & b_pipe[i][1:0];

        assign y_pipe[i] = { {1'b0}, a_pipe[i][0], b_pipe[i][0] };
    end
endgenerate

assign Y = y_pipe[3];

endmodule