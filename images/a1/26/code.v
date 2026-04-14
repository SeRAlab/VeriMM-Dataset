module binary_counter (
    input clk,
    input reset,
    input load,
    input [3:0] load_value,
    output reg [3:0] count);always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end else if (load) begin
        count <= load_value;
    end else begin
        count <= count + 1;
    end
end
endmodule