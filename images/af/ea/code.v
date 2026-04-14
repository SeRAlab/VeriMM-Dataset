module loadable_counter(
    input clk,
    input load,
    input enable,
    input [3:0] load_val,
    output reg [3:0] count
);
always @(posedge clk) begin
    if (load)
        count <= load_val;
    else if (enable)
        count <= count + 1;
end
endmodule