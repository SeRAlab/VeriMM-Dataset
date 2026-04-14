module pipelined_multiplier 
#(
parameter DATAWIDTH = 16
)
(
  input                        clk,
  input                        rst,
  input  [DATAWIDTH-1:0]       a,
  input  [DATAWIDTH-1:0]       b,
  output reg [2*DATAWIDTH-1:0] result,
  output reg                   valid
);

reg [DATAWIDTH-1:0] a_reg1, b_reg1;
reg [2*DATAWIDTH-1:0] result_reg1, result_reg2;
reg valid_reg1, valid_reg2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        a_reg1 <= {DATAWIDTH{1'b0}};
        b_reg1 <= {DATAWIDTH{1'b0}};
        result_reg1 <= {2*DATAWIDTH{1'b0}};
        result_reg2 <= {2*DATAWIDTH{1'b0}};
        valid_reg1 <= 1'b0;
        valid_reg2 <= 1'b0;
        result <= {2*DATAWIDTH{1'b0}};
        valid <= 1'b0;
    end else begin
        // Stage 1
        a_reg1 <= a;
        b_reg1 <= b;
        valid_reg1 <= 1'b1;

        // Stage 2
        result_reg1 <= a_reg1 * b_reg1;
        valid_reg2 <= valid_reg1;

        // Stage 3
        result_reg2 <= result_reg1;
        result <= result_reg2;
        valid <= valid_reg2;
    end
end

endmodule