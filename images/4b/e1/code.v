module up_down_counter (
    input clk,
    input up_dn,
    output reg [2:0] count
);
always @(posedge clk) begin
    if (up_dn)
        count <= count + 1;
    else
        count <= count - 1;
end
endmodule