module top_module(
    input [7:0] a,
    input [7:0] b,
    input clk,           // Added clk input
    output reg [2:0] count
);reg [3:0] shift_reg_a;
reg [3:0] shift_reg_b;

always @(posedge clk) begin
    shift_reg_a <= {shift_reg_a[2:0], a[3:0]};
    shift_reg_b <= {shift_reg_b[2:0], b[3:0]};
    
    if (shift_reg_a[3:0] == shift_reg_b[3:0]) begin
        count <= count + 1;
    end
end

endmodule