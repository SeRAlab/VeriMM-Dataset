module top_module(i_CLK, i_RST_n, i_OP1, i_OP2, o_RESULT);input           i_CLK;
input           i_RST_n;
input   [63:0]  i_OP1;
input   [63:0]  i_OP2;
output  [127:0] o_RESULT;

reg  [63:0] op1_r;  
reg  [63:0] op2_r; 

reg  [127:0] result_r;


always @(posedge i_CLK, negedge i_RST_n)
    if (~i_RST_n) begin
        op1_r <= 64'd0;
        op2_r <= 64'd0;
    end else begin
        op1_r <= i_OP1;
        op2_r <= i_OP2;
    end

always @(posedge i_CLK, negedge i_RST_n)
    if (~i_RST_n) begin
        result_r <= 128'd0;
    end else begin
        result_r <= op1_r*op2_r;
    end

assign o_RESULT = result_r;

endmodule