module down_counter_with_load(
    input clk,
    input load,
    input [9:0] load_value,
    output reg [9:0] count);

always @(posedge clk) begin
    if (load)
        count <= load_value;
    else
        count <= count - 1;
end
endmodule