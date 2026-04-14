module flexible_up_counter
(
    input clk,
    input ld,
    input sreset,
    input areset,
    input [8:0] load_val,
    output reg [8:0] count
);always @(posedge clk or posedge areset)
    if (areset) begin
        count <= 9'b0;
    end else if (sreset) begin
        count <= 9'b0;
    end else if (ld) begin
        count <= load_val;
    end else begin
        count <= count + 1;
    end
endmodule