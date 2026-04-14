module up_counter_with_load
(
    input clk,
    input ld,
    input sreset,
    input [5:0] load_val,
    output reg [5:0] count
);always @(posedge clk)
    if (sreset) begin
        count <= 6'b0;
    end else if (ld) begin
        count <= load_val;
    end else begin
        count <= count + 1;
    end
endmodule