module top_module(a,b,a_lt_b,a_eq_b,a_gt_b);input [1:0]a;
input [1:0]b;
output reg a_lt_b,a_eq_b,a_gt_b;
always @(a or b)
begin
a_eq_b <= (a[0] && b[0] || ~a[0] && ~b[0]) && (a[1] && b[1] || ~a[1] && ~b[1]);

a_lt_b <= !a[1] && b[1] || (a[1] && b[1] || ~a[1] && ~b[1]) && !a[0] && b[0];

a_gt_b <= a[1] && !b[1] || (a[1] && b[1] || ~a[1] && ~b[1]) && a[0] && !b[0];
end
endmodule