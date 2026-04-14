module preset_counter (
    input clk,
    input reset,
    input load,
    input [3:0] preset_val,
    output reg [3:0] count);

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (load) begin
        count <= preset_val;
    end else begin
        count <= count + 1;
    end
end
endmodule